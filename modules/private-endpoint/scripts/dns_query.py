import argparse
import re
import time
import sys
import subprocess

required_packages = {
    'dnspython': 'dns',
    'wrapt-timeout-decorator': 'timeout'
}

def install_missing_packages(packages):
    for package_name, module_name in packages.items():
        try:
            __import__(module_name)
        except:
            subprocess.check_call([sys.executable, "-m", "pip", "-qq", "install", package_name])
            
install_missing_packages(required_packages)

try:
    from dns import resolver
    from dns.exception import (DNSException, Timeout)
    from dns.resolver import (NXDOMAIN, NoAnswer, NoNameservers)
    from wrapt_timeout_decorator import *
except ImportError as e:
    print(f"Error importing packages: {e}")
    sys.exit(1)

class color:
    reset = '\033[0m'
    red = '\033[31m'
    green = '\033[32m'
    yellow = '\033[33m'
    blue = '\033[34m'
    purple = '\033[35m'
    teal = '\033[36m'
    bold = '\033[1m'
    bred = bold + red
    bgreen = bold + green
    byellow = bold + yellow
    bblue = bold + blue
    bpurple = bold + purple
    bteal = bold + teal

def dns_sleep(seconds: int):
    print(f"\n{color.bblue}Sleeping for {seconds} Seconds{color.reset}")
    time.sleep(seconds)

def dns_msg(exception: str, msg: str):
    print(f"\n{color.bteal}{exception}{color.reset}: {msg}")

@timeout(dec_timeout='script_timeout_seconds')
def dns_nslookup(fqdn: str, private_ip_list: list):
    
    if(len(private_ip_list) == 0):
        print(f"\n\n{color.bred}Error: variable 'private_ip' has not been set.\n{color.reset}")
        exit()
    
    else:
        resolver_cache = resolver.Cache()
        resolver_setup = resolver.Resolver()
        
        dns_answer_address = None
        
        while dns_answer_address not in private_ip_list:
            try:
                print(f"\n\n{color.byellow}Flushing DNS Resolver Cache.{color.reset}")
                resolver_cache.flush()
                
                print(f"\n\n{color.byellow}Checking{color.reset} to see if {color.blue}{fqdn}{color.reset} resolves to an IP address in the list: {color.purple}{private_ip_list}{color.reset}.")
                
                dns_answer = resolver_setup.resolve(fqdn, 'A')
                dns_answer_address = str(dns_answer[0])
                
                if dns_answer_address in private_ip_list:
                    print(f"\n\n{color.bgreen}Evaluation Success{color.reset}\n{color.blue}{fqdn}{color.reset} resolves to {color.purple}{dns_answer_address}{color.reset} which is present in the list: {color.purple}{private_ip_list}{color.reset}.")
                    break
                
                else:
                    dns_msg("No Exception has occurred, DNS record has not been created yet")
                    dns_sleep(5)
                    continue
                
            except NXDOMAIN:
                dns_msg("Exception NXDOMAIN", f"'A' Record for {color.blue}{fqdn}{color.reset} has not been created yet")
                dns_sleep(20)
                continue
            
            except NoAnswer:
                dns_msg("Exception NoAnswer", "DNS response doesn't contain an answer to the query")
                dns_sleep(20)
                continue
            
            except NoNameservers:
                dns_msg("Exception NoNameservers", "All nameservers failed to respond to the query")
                dns_sleep(5)
                continue
            
            except Timeout:
                dns_msg("Exception Timeout", "DNS Query timeout")
                dns_sleep(5)
                continue
            
            except DNSException as e:
                print(f"\n\n{color.byellow}Unexpected Exception{color.reset}:")
                print(f"\n{e}\n")
                dns_sleep(3)
                continue

if __name__ == "__main__":
    parse_argvalues = argparse.ArgumentParser()
    
    parse_argvalues.add_argument(
        '--private_ip', required=True, dest='private_ip',
        help='input private ip from resource block using self. argument format.' 
    )
    
    parse_argvalues.add_argument(
        '--fqdn', required=True, dest='fqdn', type=str,
        help='private endpoint dns record to validate. e.g. aks.privatelink.centralus.azmk8s.io' 
    )
    
    parse_argvalues.add_argument(
        '--time-out', required=True, dest='timeout', type=int,
        help='Sets the value of the @timeout decorator for the main dns query function.' 
    )
    
    args = parse_argvalues.parse_args()
    
    fqdn = args.fqdn
    private_ip = args.private_ip
    script_timeout_seconds = args.timeout
    ip_regex = '(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'
    
    private_ip_list = re.findall(ip_regex, private_ip)
    
    try:
        dns_nslookup(fqdn, private_ip_list, dec_timeout=script_timeout_seconds)
    
    except TimeoutError:
        print(f"\n\nThe script has {color.red}Timed out{color.reset} by reaching the value of {color.red}{script_timeout_seconds} seconds{color.reset}.\n\n\
            {color.red}Exiting ...{color.reset}")
        
        print(f"\n\nDNS Validation can be done manually, as needed by issuing one of the following commands:\n")
        
        if len(private_ip_list) != 0:
            for ip in private_ip_list:
                print(f"{color.bblue}For IP {ip}:{color.reset}\n\
                    {color.green}nslookup {fqdn} | egrep \"(^Address: {ip}|server can't)\"{color.reset}\n\
                        or\n\
                            {color.green}host {fqdn} | egrep \"(^has address {ip}|not found)\"{color.reset}\n")
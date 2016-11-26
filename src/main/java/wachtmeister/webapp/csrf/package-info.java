/**
 * Trying to implement some csrf-defense techniques following owasp
 * recommendations.
 * 
 * 
 * https://www.owasp.org/index.php/Cross-Site_Request_Forgery_(CSRF)
 * _Prevention_Cheat_Sheet
 *
 * Summary: "verifying that the user intentionally submitted the request" 1.
 * assert same origin (http-header ORIGIN/REFERER == SERVER.ADRESS.API) 2.
 * 
 * 
 * 
 * 
 * further reading:
 * http://security.stackexchange.com/questions/59470/double-submit-cookies-
 * vulnerabilities#61039
 *
 */
package wachtmeister.webapp.csrf;

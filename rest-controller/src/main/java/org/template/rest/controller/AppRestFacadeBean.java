package org.template.rest.controller;

import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.ws.rs.Path;

/**
 * @author Victor Mezrin
 */
@Stateless
@Path("/")
public class AppRestFacadeBean {

    @EJB(name = "UserControllerRestEJB")
    UserControllerRestBean user;

    @Path("user")
    public UserControllerRestBean getUserControllerRestBean() {
        return this.user;
    }
}

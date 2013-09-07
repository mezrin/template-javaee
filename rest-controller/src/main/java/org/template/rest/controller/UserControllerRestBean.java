package org.template.rest.controller;

import org.template.controller.IUserController;
import org.template.rest.model.RequestNewUser;
import org.template.rest.model.ServerResponse;

import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

/**
 * @author Victor Mezrin
 */
@Stateless(name = "UserControllerRestEJB")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
public class UserControllerRestBean {

    @EJB(name = "UserControllerEJB")
    IUserController userController;

    @POST
    @Path("/persist")
    public ServerResponse persistUser(@Context HttpServletRequest requestContext,
                                      RequestNewUser request) {
        this.userController.persistUser(request.getFirstName(), request.getLastName());

        ServerResponse response = new ServerResponse();
        response.setResult(true);
        return response;
    }
}

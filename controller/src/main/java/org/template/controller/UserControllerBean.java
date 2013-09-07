package org.template.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.template.model.User;

import javax.annotation.Resource;
import javax.ejb.Local;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

/**
 * @author Victor Mezrin
 */
@Stateless(name = "UserControllerEJB")
@Local(IUserController.class)
public class UserControllerBean implements IUserController {

    @PersistenceContext(unitName = "MainPersistenceUnit")
    private EntityManager em;
    private Logger LOG = LoggerFactory.getLogger(UserControllerBean.class);

    @Resource(name = "NamePrefix")
    private String NamePrefix;


    @Override
    public void persistUser(String firstName, String lastName) {
        User user = new User();
        user.setFirstName(this.NamePrefix + " " + firstName);
        user.setLastName(lastName);
        this.em.persist(user);
        this.LOG.info("User {} {} persisted", firstName, lastName);
    }
}

package org.template.rest.controller;

import javax.ws.rs.core.Application;
import java.util.HashSet;
import java.util.Set;

/**
 * @author Victor Mezrin
 */
public class AppRestApplication extends Application {

    @Override
    public Set<Class<?>> getClasses() {
        Set<Class<?>> classes = new HashSet<>();
        classes.add(AppRestFacadeBean.class);
        classes.add(UserControllerRestBean.class);
        return classes;
    }
}

package org.template.rest.model;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Victor Mezrin
 */
@XmlRootElement
public class ServerResponse {

    boolean result;

    public boolean isResult() {
        return result;
    }

    public void setResult(boolean result) {
        this.result = result;
    }
}

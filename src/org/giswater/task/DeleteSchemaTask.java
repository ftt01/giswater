/*
 * This file is part of Giswater
 * Copyright (C) 2013 Tecnics Associats
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 * 
 * Author:
 *   David Erill <derill@giswater.org>
 */
package org.giswater.task;

import java.util.Vector;

import org.giswater.dao.MainDao;
import org.giswater.gui.MainClass;
import org.giswater.util.Utils;


public class DeleteSchemaTask extends ParentSchemaTask {	
	
	
	public DeleteSchemaTask(String waterSoftware, String schemaName) {
		super(waterSoftware, schemaName);
	}
	
	
    @Override
    public Void doInBackground() { 
		
    	setProgress(1);
    	
    	// Disable view
    	Utils.setPanelEnabled(parentPanel, false);

    	parentPanel.requestFocusInWindow();     	
    	MainDao.deleteSchema(schemaName);
		Vector<String> schemaList = MainDao.getSchemas(waterSoftware);
		boolean enabled = parentPanel.setSchemaModel(schemaList);
		controller.enablePreprocess(enabled);
		controller.setSchema(parentPanel.getSelectedSchema());
		
		// Enable view
    	Utils.setPanelEnabled(parentPanel, true);
    	controller.schemaChanged();
    	status = true;
    	
		return null;
    	
    }

    
    public void done() {
    	
    	MainClass.mdi.setProgressBarEnd();
    	if (status) {
    		MainClass.mdi.showMessage("schema_deleted");
    	}
    	else {
    		MainClass.mdi.showError("project_not_deleted");
    	}
		
    }

    
}
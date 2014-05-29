/*
 * Copyright 2014 Kokorin Denis
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package ru.kokorin.astream {
import as3.lang.Enum;

public class AStreamMode extends Enum {
    public static const NO_REFERENCES:AStreamMode = new AStreamMode("NO_REFERENCES");
    public static const ID_REFERENCES:AStreamMode = new AStreamMode("ID_REFERENCES");
    public static const XPATH_ABSOLUTE_REFERENCES:AStreamMode = new AStreamMode("XPATH_ABSOLUTE_REFERENCES");
    public static const XPATH_RELATIVE_REFERENCES:AStreamMode = new AStreamMode("XPATH_RELATIVE_REFERENCES");
    public static const SINGLE_NODE_XPATH_ABSOLUTE_REFERENCES:AStreamMode = new AStreamMode("SINGLE_NODE_XPATH_ABSOLUTE_REFERENCES");
    public static const SINGLE_NODE_XPATH_RELATIVE_REFERENCES:AStreamMode = new AStreamMode("SINGLE_NODE_XPATH_RELATIVE_REFERENCES");

    public function AStreamMode(name:String) {
        super(name);
    }
}
}

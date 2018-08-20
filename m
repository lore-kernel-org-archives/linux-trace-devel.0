Return-Path: <SRS0=Itc8=LD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:34932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbeHTTcm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Aug 2018 15:32:42 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Clark Williams <williams@redhat.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        linux-trace-devel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/21] tools lib traceevent: Change to SPDX License format
Date: Mon, 20 Aug 2018 13:15:45 -0300
Message-Id: <20180820161602.6830-5-acme@kernel.org>
In-Reply-To: <20180820161602.6830-1-acme@kernel.org>
References: <20180820161602.6830-1-acme@kernel.org>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Replace the GPL text with SPDX tags in the tools/lib/traceevent files.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lkml.kernel.org/r/20180816111015.125e0f25@gandalf.local.home
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c   | 16 +---------------
 tools/lib/traceevent/event-plugin.c  | 16 +---------------
 tools/lib/traceevent/event-utils.h   | 16 +---------------
 tools/lib/traceevent/kbuffer-parse.c | 17 +----------------
 tools/lib/traceevent/parse-filter.c  | 16 +---------------
 tools/lib/traceevent/parse-utils.c   | 16 +---------------
 tools/lib/traceevent/trace-seq.c     | 16 +---------------
 7 files changed, 7 insertions(+), 106 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 6313e32680ff..ce1e20227c64 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1,21 +1,7 @@
+// SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
  *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU Lesser General Public
- * License as published by the Free Software Foundation;
- * version 2.1 of the License (not later!)
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU Lesser General Public License for more details.
- *
- * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not,  see <http://www.gnu.org/licenses>
- *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  *
  *  The parts for function graph printing was taken and modified from the
  *  Linux Kernel that were written by
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index 8e324ed46547..f17e25097e1e 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -1,21 +1,7 @@
+// SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
  *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU Lesser General Public
- * License as published by the Free Software Foundation;
- * version 2.1 of the License (not later!)
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU Lesser General Public License for more details.
- *
- * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not,  see <http://www.gnu.org/licenses>
- *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
 
 #include <ctype.h>
diff --git a/tools/lib/traceevent/event-utils.h b/tools/lib/traceevent/event-utils.h
index d1dc2170e402..0560b96a31d1 100644
--- a/tools/lib/traceevent/event-utils.h
+++ b/tools/lib/traceevent/event-utils.h
@@ -1,21 +1,7 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
 /*
  * Copyright (C) 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
  *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU Lesser General Public
- * License as published by the Free Software Foundation;
- * version 2.1 of the License (not later!)
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU Lesser General Public License for more details.
- *
- * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not,  see <http://www.gnu.org/licenses>
- *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
 #ifndef __UTIL_H
 #define __UTIL_H
diff --git a/tools/lib/traceevent/kbuffer-parse.c b/tools/lib/traceevent/kbuffer-parse.c
index ca424b157e46..af2a1f3b7424 100644
--- a/tools/lib/traceevent/kbuffer-parse.c
+++ b/tools/lib/traceevent/kbuffer-parse.c
@@ -1,22 +1,7 @@
+// SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
  *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU Lesser General Public
- * License as published by the Free Software Foundation;
- * version 2.1 of the License (not later!)
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU Lesser General Public License for more details.
- *
- * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
- *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 682a50e8b5f7..e76154c02ee7 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -1,21 +1,7 @@
+// SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (C) 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
  *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU Lesser General Public
- * License as published by the Free Software Foundation;
- * version 2.1 of the License (not later!)
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU Lesser General Public License for more details.
- *
- * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not,  see <http://www.gnu.org/licenses>
- *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/tools/lib/traceevent/parse-utils.c b/tools/lib/traceevent/parse-utils.c
index eda07fa31dca..77e4ec6402dd 100644
--- a/tools/lib/traceevent/parse-utils.c
+++ b/tools/lib/traceevent/parse-utils.c
@@ -1,21 +1,7 @@
+// SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (C) 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
  *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU Lesser General Public
- * License as published by the Free Software Foundation;
- * version 2.1 of the License (not later!)
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU Lesser General Public License for more details.
- *
- * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not,  see <http://www.gnu.org/licenses>
- *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/tools/lib/traceevent/trace-seq.c b/tools/lib/traceevent/trace-seq.c
index 292dc9f1d233..e3bac4543d3b 100644
--- a/tools/lib/traceevent/trace-seq.c
+++ b/tools/lib/traceevent/trace-seq.c
@@ -1,21 +1,7 @@
+// SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (C) 2009 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
  *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU Lesser General Public
- * License as published by the Free Software Foundation;
- * version 2.1 of the License (not later!)
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU Lesser General Public License for more details.
- *
- * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not,  see <http://www.gnu.org/licenses>
- *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
 #include <stdio.h>
 #include <stdlib.h>
-- 
2.14.4

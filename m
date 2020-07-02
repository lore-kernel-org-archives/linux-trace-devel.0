Return-Path: <SRS0=hXpH=AN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7844C433E2
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 18:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CED6821924
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 18:57:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgGBS5b (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Jul 2020 14:57:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbgGBS5H (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Jul 2020 14:57:07 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5B0521D79;
        Thu,  2 Jul 2020 18:57:06 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jr4OP-004BH2-NI; Thu, 02 Jul 2020 14:57:05 -0400
Message-ID: <20200702185705.601167185@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 02 Jul 2020 14:53:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH v2 14/15] tools lib traceevent: Change to SPDX License format
References: <20200702185344.913492689@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Replaced COPYING with a description of how the SPDX identifiers are used.
Added a GPL-2.0 and LGPL-2.1 license file in the new LICENSES directory.
Then removed all the license templates from the source files and replaced
them with the corresponding SPDX identifier.

Link: http://lore.kernel.org/linux-trace-devel/20200702174950.123454-6-tz.stoyanov@gmail.com

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
[ Ported from trace-cmd.git ]
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.h              | 16 +---------------
 tools/lib/traceevent/kbuffer.h                  | 17 +----------------
 tools/lib/traceevent/plugins/plugin_function.c  | 17 +----------------
 tools/lib/traceevent/plugins/plugin_futex.c     | 16 +---------------
 tools/lib/traceevent/plugins/plugin_hrtimer.c   | 17 +----------------
 tools/lib/traceevent/plugins/plugin_jbd2.c      | 17 +----------------
 tools/lib/traceevent/plugins/plugin_kmem.c      | 17 +----------------
 tools/lib/traceevent/plugins/plugin_kvm.c       | 17 +----------------
 tools/lib/traceevent/plugins/plugin_mac80211.c  | 17 +----------------
 .../traceevent/plugins/plugin_sched_switch.c    | 17 +----------------
 tools/lib/traceevent/plugins/plugin_tlb.c       | 17 +----------------
 11 files changed, 11 insertions(+), 174 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index ac162472268b..acd6791480a4 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -1,21 +1,7 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
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
 #ifndef _PARSE_EVENTS_H
 #define _PARSE_EVENTS_H
diff --git a/tools/lib/traceevent/kbuffer.h b/tools/lib/traceevent/kbuffer.h
index 5fa8292e341b..a2b522093cfd 100644
--- a/tools/lib/traceevent/kbuffer.h
+++ b/tools/lib/traceevent/kbuffer.h
@@ -1,22 +1,7 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
 /*
  * Copyright (C) 2012 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
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
 #ifndef _KBUFFER_H
 #define _KBUFFER_H
diff --git a/tools/lib/traceevent/plugins/plugin_function.c b/tools/lib/traceevent/plugins/plugin_function.c
index 7e8e29b43d1c..807b16e1bf0f 100644
--- a/tools/lib/traceevent/plugins/plugin_function.c
+++ b/tools/lib/traceevent/plugins/plugin_function.c
@@ -1,21 +1,6 @@
+// SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
- *
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
diff --git a/tools/lib/traceevent/plugins/plugin_futex.c b/tools/lib/traceevent/plugins/plugin_futex.c
index 5d76df141401..eb7c9f8a850a 100644
--- a/tools/lib/traceevent/plugins/plugin_futex.c
+++ b/tools/lib/traceevent/plugins/plugin_futex.c
@@ -1,23 +1,9 @@
+// SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (C) 2017 National Instruments Corp.
  *
  * Author: Julia Cartwright <julia@ni.com>
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
diff --git a/tools/lib/traceevent/plugins/plugin_hrtimer.c b/tools/lib/traceevent/plugins/plugin_hrtimer.c
index bb434e0ed03a..d98466788f14 100644
--- a/tools/lib/traceevent/plugins/plugin_hrtimer.c
+++ b/tools/lib/traceevent/plugins/plugin_hrtimer.c
@@ -1,22 +1,7 @@
+// SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (C) 2009 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
  * Copyright (C) 2009 Johannes Berg <johannes@sipsolutions.net>
- *
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
diff --git a/tools/lib/traceevent/plugins/plugin_jbd2.c b/tools/lib/traceevent/plugins/plugin_jbd2.c
index 04fc125f38cb..69111a68d3cf 100644
--- a/tools/lib/traceevent/plugins/plugin_jbd2.c
+++ b/tools/lib/traceevent/plugins/plugin_jbd2.c
@@ -1,21 +1,6 @@
+// SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (C) 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
- *
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
diff --git a/tools/lib/traceevent/plugins/plugin_kmem.c b/tools/lib/traceevent/plugins/plugin_kmem.c
index edaec5d962c3..4b4f7f9616e3 100644
--- a/tools/lib/traceevent/plugins/plugin_kmem.c
+++ b/tools/lib/traceevent/plugins/plugin_kmem.c
@@ -1,21 +1,6 @@
+// SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (C) 2009 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
- *
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
diff --git a/tools/lib/traceevent/plugins/plugin_kvm.c b/tools/lib/traceevent/plugins/plugin_kvm.c
index 768c658f5904..de76a1e79d9e 100644
--- a/tools/lib/traceevent/plugins/plugin_kvm.c
+++ b/tools/lib/traceevent/plugins/plugin_kvm.c
@@ -1,21 +1,6 @@
+// SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (C) 2009 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
- *
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
diff --git a/tools/lib/traceevent/plugins/plugin_mac80211.c b/tools/lib/traceevent/plugins/plugin_mac80211.c
index 884303c26b5c..f48071e3cfb8 100644
--- a/tools/lib/traceevent/plugins/plugin_mac80211.c
+++ b/tools/lib/traceevent/plugins/plugin_mac80211.c
@@ -1,21 +1,6 @@
+// SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (C) 2009 Johannes Berg <johannes@sipsolutions.net>
- *
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
diff --git a/tools/lib/traceevent/plugins/plugin_sched_switch.c b/tools/lib/traceevent/plugins/plugin_sched_switch.c
index 957389a0ff7a..e12fa103820a 100644
--- a/tools/lib/traceevent/plugins/plugin_sched_switch.c
+++ b/tools/lib/traceevent/plugins/plugin_sched_switch.c
@@ -1,21 +1,6 @@
+// SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
- *
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
diff --git a/tools/lib/traceevent/plugins/plugin_tlb.c b/tools/lib/traceevent/plugins/plugin_tlb.c
index 1adade776306..43657fb60504 100644
--- a/tools/lib/traceevent/plugins/plugin_tlb.c
+++ b/tools/lib/traceevent/plugins/plugin_tlb.c
@@ -1,21 +1,6 @@
+// SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright (C) 2015 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
- *
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
2.26.2



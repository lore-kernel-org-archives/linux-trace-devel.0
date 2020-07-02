Return-Path: <SRS0=hXpH=AN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1993EC433E6
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 17:50:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5DD820885
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 17:50:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W2n9igbO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgGBRuC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Jul 2020 13:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727990AbgGBRuC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Jul 2020 13:50:02 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7140C08C5C1
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Jul 2020 10:50:01 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id f18so29266688wml.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Jul 2020 10:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ydVW9/521/bdy11VljdJXK50sbfoBZQdxRTMaN3cFpY=;
        b=W2n9igbOFjVFcuqH/YJtYKb/US5pFio6Ix7/LalqaGXGvcdFHAt8Wyc1GdVCMkbOLg
         9UIrUu+8QXYBAFo/tqLDzqCXlV1g49rQniV84XH9zXSKGbJCbUHci5kLdCcZa5579Wpr
         JuuSCpA/kya5t+jT/xlvqh9Ej3mO/kOSADVDQxWvLodaPHPumXCf8rFHU4BqA/7DyuFK
         W/HMJzKNvou3sBJD1BCmrWfQu6frZWgcRaBmMuRKI/MRyzbOF/1vp8U/vA1RBy9vNd6E
         5ZcFUji72uwTKxeFxdLRp8AbGaCIy1y+YQu4nBCNCKHLEe50gMqNCuomuxU+fG27/tCY
         hpmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ydVW9/521/bdy11VljdJXK50sbfoBZQdxRTMaN3cFpY=;
        b=MAlJVy6NdW7gGvDHjBRI3GOpMuXqcCWgNsZPjpH6AtVh4hiJneOt1jI69ti+n5cC0L
         YmHi7ExRIA4pLArPNK+pRCTTnv7DRgJRbjwM8Hg6AeBrgifjzRjVwICKZVW2f0lUgfuY
         hD6issKjTb9KfngIl9UgH4QPKXOR9Btrk1KBCXnaDaxTM4+r8+oRfd155MP3Llv6jWA0
         ZxA881V3TI3tQ9QxPdCbJUjrxMtLAgFJk/MxFao6Z+4fj29AcS5RDoYyvmbhAe4j3cPt
         l9/ZyWJJoERt5fHkfvWXWW9Q6YDYiqw8fXqZkIVktq6bxoIQIXUlwn5dJvyyZMRUGX4C
         YE+A==
X-Gm-Message-State: AOAM530fS0iYaMIe7Mn1OXXD2WKI2uGnmKFJ5guHqnB38vxebvxNA1ys
        LkFF3cABVCPLpT4d4cwLe2T0me0h1Vw=
X-Google-Smtp-Source: ABdhPJz6abYUEWP3uzqxypmS9z1MgobTeRBMj+qy4dLPoft+gQdwxF7z5dn2xq58ft0XEXRvr23dCw==
X-Received: by 2002:a05:600c:2241:: with SMTP id a1mr31846395wmm.168.1593712200112;
        Thu, 02 Jul 2020 10:50:00 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g82sm9289319wma.37.2020.07.02.10.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 10:49:59 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 14/15] tools lib traceevent: Change to SPDX License format
Date:   Thu,  2 Jul 2020 20:49:49 +0300
Message-Id: <20200702174950.123454-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200702174950.123454-1-tz.stoyanov@gmail.com>
References: <20200702174950.123454-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

Replaced COPYING with a description of how the SPDX identifiers are used.
Added a GPL-2.0 and LGPL-2.1 license file in the new LICENSES directory.
Then removed all the license templates from the source files and replaced
them with the corresponding SPDX identifier.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
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


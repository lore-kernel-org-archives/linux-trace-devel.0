Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A7FFC54EBE
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Jan 2023 22:53:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235434AbjAIWxW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 9 Jan 2023 17:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237300AbjAIWxU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 9 Jan 2023 17:53:20 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7850C15FC6
        for <linux-trace-devel@vger.kernel.org>; Mon,  9 Jan 2023 14:53:19 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id o8-20020a17090a9f8800b00223de0364beso14421163pjp.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 09 Jan 2023 14:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T2bEIK2lTEsiEgKIaSYuZQGDn//iZl/Z/3/8jhg9B1U=;
        b=GzGg3S0LkrGj4BIgOPZb9h8AjX4KXdnoVjE/QbK/v9in0fOncl7n/DdplXFjE7mRx7
         L+8wT9qEzkSsMhlagGzwWqlvxwm16G2UvemcfNrGuw/5LKz3iSTq3KTwoka/HXPm3wMZ
         Nl1P0KcnCMxfsy1jHjQiweOdZLX3rSHVIEJv680icDcA785lTd3A6aStupbIR3WjzYQj
         hIO8nQVpJtnZPg77LWbBHIMT4uf8iLNB+LZdfZaA9SejgF9CfEVe5tBVChbTFdRhaw2i
         RREOjEFnIt6vFDHx2eyQ5T458a8keaJyYImMV2c/daZhA881yDMWspTqXQJ7GZZoREkK
         SBKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T2bEIK2lTEsiEgKIaSYuZQGDn//iZl/Z/3/8jhg9B1U=;
        b=xl36xWXbBXp6DggMpcwas3dYAI1ogzoFUdnGMFvl/vlm8zsxlb/SYUCqQCgHHgiblU
         PQCbjCnhbSpQR/eTOwFqztnAIZnqrrbCbYidLnBu8C3sR++SJqVRM4QBp6XprYghjV/W
         h6wICXgABnvQUa+GO9yKTXi37wZgHMuKF1FGZCEHjXZszI1ayIoVV9ZARucC66pk2Xaq
         9cXsj0i3jK09XDy69Ib5/Mb3X/kV38aoDFHQz0FM/Cu01T5AgzM4KNM4Wc+/rbGOURLh
         /GojLBFCklnw2uVOQuMO/JQKkR5A59sToiXZJYsnH+owDComDTXQ8pSYYAdzOuea7M7E
         UThw==
X-Gm-Message-State: AFqh2kpVJCbo2OSBdcw1Ee4H9jK4uathrdswYVwS3M1Mvk0X/ut6+gS+
        FOJJUwiapMUdZWLQtcgo6dVHKqjo0dTE0g==
X-Google-Smtp-Source: AMrXdXt6GGVq37g+uLdlt1OylCrWWX/VIuN9IDYdPnyxjV2uEtgroW/ZSEGjecMCzmmXcoEB1b8Rtg==
X-Received: by 2002:a17:902:d4d1:b0:189:c322:df3a with SMTP id o17-20020a170902d4d100b00189c322df3amr93254446plg.43.1673304798643;
        Mon, 09 Jan 2023 14:53:18 -0800 (PST)
Received: from apollo.hsd1.ca.comcast.net ([2601:646:9181:1cf0::ee35])
        by smtp.gmail.com with ESMTPSA id n2-20020a170902d2c200b00192fe452e17sm6602662plc.162.2023.01.09.14.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 14:53:18 -0800 (PST)
From:   Khem Raj <raj.khem@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Khem Raj <raj.khem@gmail.com>
Subject: [PATCH 2/2] Drop using _LARGEFILE64_SOURCE
Date:   Mon,  9 Jan 2023 14:53:15 -0800
Message-Id: <20230109225315.1284538-2-raj.khem@gmail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230109225315.1284538-1-raj.khem@gmail.com>
References: <20230109225315.1284538-1-raj.khem@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Its no longer needed since we have dropped using LF64 interfaces

Signed-off-by: Khem Raj <raj.khem@gmail.com>
---
 lib/trace-cmd/trace-input.c    | 1 -
 lib/trace-cmd/trace-output.c   | 1 -
 lib/trace-cmd/trace-recorder.c | 1 -
 tracecmd/trace-hist.c          | 1 -
 tracecmd/trace-listen.c        | 1 -
 tracecmd/trace-mem.c           | 1 -
 tracecmd/trace-profile.c       | 1 -
 tracecmd/trace-read.c          | 1 -
 tracecmd/trace-restore.c       | 1 -
 tracecmd/trace-split.c         | 1 -
 10 files changed, 10 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 9b128403..3dd13ce4 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3,7 +3,6 @@
  * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
  *
  */
-#define _LARGEFILE64_SOURCE
 #include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index ad740d65..eee847e3 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -3,7 +3,6 @@
  * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
  *
  */
-#define _LARGEFILE64_SOURCE
 #include <dirent.h>
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index c172ad64..70ce52e2 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -3,7 +3,6 @@
  * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
  *
  */
-#define _LARGEFILE64_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <fcntl.h>
diff --git a/tracecmd/trace-hist.c b/tracecmd/trace-hist.c
index efb790ac..62fe4f9b 100644
--- a/tracecmd/trace-hist.c
+++ b/tracecmd/trace-hist.c
@@ -5,7 +5,6 @@
  * Several of the ideas in this file came from Arnaldo Carvalho de Melo's
  * work on the perf ui.
  */
-#define _LARGEFILE64_SOURCE
 #include <dirent.h>
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 86d2b9e9..e95c5711 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -3,7 +3,6 @@
  * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
  *
  */
-#define _LARGEFILE64_SOURCE
 #include <dirent.h>
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/tracecmd/trace-mem.c b/tracecmd/trace-mem.c
index 25eb0861..3e1ac9f3 100644
--- a/tracecmd/trace-mem.c
+++ b/tracecmd/trace-mem.c
@@ -11,7 +11,6 @@
  * was written for the newer version. I decided to do some of it here
  * in C.
  */
-#define _LARGEFILE64_SOURCE
 #include <dirent.h>
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/tracecmd/trace-profile.c b/tracecmd/trace-profile.c
index 6a2cc3d0..d12a0e5e 100644
--- a/tracecmd/trace-profile.c
+++ b/tracecmd/trace-profile.c
@@ -5,7 +5,6 @@
  */
 
 /** FIXME: Convert numbers based on machine and file */
-#define _LARGEFILE64_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index c094ad6a..52ba818e 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -3,7 +3,6 @@
  * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
  *
  */
-#define _LARGEFILE64_SOURCE
 #include <dirent.h>
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/tracecmd/trace-restore.c b/tracecmd/trace-restore.c
index 5bf29c52..e9ca3225 100644
--- a/tracecmd/trace-restore.c
+++ b/tracecmd/trace-restore.c
@@ -3,7 +3,6 @@
  * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
  *
  */
-#define _LARGEFILE64_SOURCE
 #include <dirent.h>
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index 851ec94e..1daa847d 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -3,7 +3,6 @@
  * Copyright (C) 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
  *
  */
-#define _LARGEFILE64_SOURCE
 #include <dirent.h>
 #include <stdio.h>
 #include <stdlib.h>
-- 
2.39.0


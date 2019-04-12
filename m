Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90A2DC282CE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6762B2084D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfDLNiT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:38:19 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34260 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbfDLNiT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 09:38:19 -0400
Received: by mail-wr1-f68.google.com with SMTP id p10so12034626wrq.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 06:38:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1KgDXdXVNQ5+zLav00nRVLOERuuQFC9ZZ+74zZDhbYU=;
        b=AZZ34CEMuCH+SrVFAg9an7L81SWU6vXw56QDElUt5LEcADi5NSSqPHfVU0AjDNPMQr
         QLOc5P4d13CryZ4Ik2xPYJQp2Rg/d7utRtiU1n0InxOoB7/vEGZ1B1ddIx4juUXzqgx+
         FJ1u/XBe2a41GI0YVD4gvAJ62JfZcOuvMstR/WUwYakNCsaq7L7HQCRzbNTSFfl2PJ1E
         ZRwuukK6Jzao5BBiVzKmd7IO/TTt2f0PYhpQtjohw1mn3IWEoKvyB1IMw3gJPzMFfrAw
         vLqijm8hnRiW2yzyI7L/odSNfqZVY5NLz20cXvnVtrYOOSyfweMDrl0l34JcTOAlopYj
         AoZw==
X-Gm-Message-State: APjAAAWVTKpsx9msB1J9PrwYCke+kG8FtTiPThKhVNsi+B5Ru+XYXeQW
        bIf9aNYn85TsH0QpVVik75U=
X-Google-Smtp-Source: APXvYqySeY32/k9qAEJ/+flk2DlfZaQxy5w7cZK0YlR0MOE3KyR3BxTjONniZhn9FDIb7usHOXEjKQ==
X-Received: by 2002:adf:fd86:: with SMTP id d6mr15739723wrr.15.1555076297305;
        Fri, 12 Apr 2019 06:38:17 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x205sm11594682wmg.9.2019.04.12.06.38.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Apr 2019 06:38:16 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 05/30] tools/lib/traceevent: Man page for get/set cpus APIs
Date:   Fri, 12 Apr 2019 16:37:46 +0300
Message-Id: <20190412133811.15878-6-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190412133811.15878-1-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for libtraceevent APIs:
 tep_get_cpus(),
 tep_set_cpus()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-cpus.txt      | 77 +++++++++++++++++++
 1 file changed, 77 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-cpus.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-cpus.txt b/tools/lib/traceevent/Documentation/libtraceevent-cpus.txt
new file mode 100644
index 000000000000..5ad70e43b752
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-cpus.txt
@@ -0,0 +1,77 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_get_cpus, tep_set_cpus - Get / set the number of CPUs, which have a tracing
+buffer representing it. Note, the buffer may be empty.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_get_cpus*(struct tep_handle pass:[*]_tep_);
+void *tep_set_cpus*(struct tep_handle pass:[*]_tep_, int _cpus_);
+--
+
+DESCRIPTION
+-----------
+The _tep_get_cpus()_ function gets the number of CPUs, which have a tracing
+buffer representing it. The _tep_ argument is trace event parser context.
+
+The _tep_set_cpus()_ function sets the number of CPUs, which have a tracing
+buffer representing it. The _tep_ argument is trace event parser context.
+The _cpu_ argument is the number of CPUs with tracing data.
+
+RETURN VALUE
+------------
+The _tep_get_cpus()_ functions returns the number of CPUs, which have tracing
+data recorded.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+	tep_set_cpus(tep, 5);
+...
+	printf("We have tracing data for %d CPUs", tep_get_cpus(tep));
+--
+
+FILES
+-----
+[verse]
+--
+*event-parse.h*
+	Header file to include in order to have access to the library APIs.
+*-ltraceevent*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtraceevent(3)_, _trace-cmd(1)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man page.
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtraceevent is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
-- 
2.20.1


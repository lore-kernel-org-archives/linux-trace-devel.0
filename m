Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBBC2C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9436D2087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfCHNhI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:08 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36139 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfCHNhI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:08 -0500
Received: by mail-wm1-f65.google.com with SMTP id j125so12490722wmj.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EguOzs7yESnH6Jymq7twdKCOGCQJBqvt7aeCpQRnT1c=;
        b=pWpVXY/rOUu1twNOe3CxAn3604BLqvoiCy0KoGInWPPWOo0bOZrwwR+Ta+o/tIB0I8
         ooDiIKuGRFNTSVytCJoh8cEQuenE/80tUgUOxHCSnuhgVWiX4s9v0O7/yVuF4iKCaLpF
         vXfexLSVcgrG7tinRwGyGfDzDG8Hc2p6K7CJGyVh+ZGxzhMkM/pIR4/vx4mi/ByZq16q
         /dlyKEnScHYtVZPUhiZQAU+wpZuOR7uTE89rc1RnvgtsTsm8jU08Wft7+gNQ1RgTPlwZ
         FbKmKvVUte4UYwzmx66ZFbG0ssrdLoSdyDCXD2hAHu0AR3bjTX21r88UKndIEWdz3/ap
         peXQ==
X-Gm-Message-State: APjAAAVaYtus2BwWQcQqGIZWXCaKjOa6cRxYGpOjbB7OqRbtTHA9gaRn
        rnQKQGaqHah7miwN4JJ//RwUgjsK
X-Google-Smtp-Source: APXvYqz16G6wI+P2Vzk+rcoOLY8dYLdXeXDxlyZx7juawPPC41KRfthrohlTSolikVYr5GeJv3wFxw==
X-Received: by 2002:a05:600c:2115:: with SMTP id u21mr9716660wml.70.1552052226040;
        Fri, 08 Mar 2019 05:37:06 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:05 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 09/46] tools/lib/traceevent: Man page for tep_is_host_bigendian() and tep_set_host_bigendian()
Date:   Fri,  8 Mar 2019 15:36:17 +0200
Message-Id: <20190308133654.21264-10-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for tep_is_host_bigendian() and tep_set_host_bigendian()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-host_endian.txt             | 91 +++++++++++++++++++
 1 file changed, 91 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-host_endian.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-host_endian.txt b/tools/lib/traceevent/Documentation/libtraceevent-host_endian.txt
new file mode 100644
index 000000000000..de2aab90c8cf
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-host_endian.txt
@@ -0,0 +1,91 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_is_host_bigendian,tep_set_host_bigendian,tep_host_bigendian - Get / set the
+endianness of the machine running the current code.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+enum *tep_endian* {
+	TEP_LITTLE_ENDIAN = 0,
+	TEP_BIG_ENDIAN
+};
+
+int *tep_is_host_bigendian*(struct tep_handle pass:[*]_tep_);
+void *tep_set_host_bigendian*(struct tep_handle pass:[*]_tep_, enum tep_endian _endian_);
+int tep_host_bigendian(void);
+--
+
+DESCRIPTION
+-----------
+The _tep_is_host_bigendian()_ function returns the endianness of the the machine
+running the current code. The _tep_ argument is the trace event parser context.
+
+The _tep_set_host_bigendian()_ set the endianness of the machine running the code.
+The _tep_ argument is trace event parser context. The _endian_ argument is the
+endianness:
+[verse]
+--
+	_TEP_LITTLE_ENDIAN_ - the machine is little endian,
+	_TEP_BIG_ENDIAN_ - the machine is big endian.
+--
+
+RETURN VALUE
+------------
+The _tep_is_host_bigendian()_ function returns _TEP_LITTLE_ENDIAN_ or _TEP_BIG_ENDIAN_.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+	tep_set_host_bigendian(tep, TEP_LITTLE_ENDIAN);
+...
+	if (TEP_BIG_ENDIAN == tep_is_host_bigendian(tep)) {
+		/* The local host is big endian */
+	} else {
+		/* The local host is little endian */
+	}
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


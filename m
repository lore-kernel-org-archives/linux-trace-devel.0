Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3165FC282CE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF3692084D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfDLNii (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:38:38 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55497 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727032AbfDLNii (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 09:38:38 -0400
Received: by mail-wm1-f65.google.com with SMTP id o25so11275865wmf.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 06:38:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hvSaUKiMrEKZHSsIz9xkKhvhxLIm2GB1TGjnPbucNFo=;
        b=oUmockxGz/4iy2Pi+meZxSxD7OalHulQol6Jo44FVlD5nPWvRWL/mxLI7XE14uKvGg
         p/cJ3MRgUWIqc7yHtmd7waHZMBC6T5Nfy/ZOR74arMTNwlpfwvqcGQlLOj/rCkQcxm+L
         uV8wuljj90AFC8Hf39DfdQnKeMC+2+tUstwHzs1uD725Qqt95vfx9NsKyjhJh+ase6xa
         myk80f5rSWPUeQRi1pT2bhl3C9Bj5PILh5EbP2dq0SvodjSRtiol9jpjKecRbghHS2B6
         Qq2bgN0rn9J20y8pURcDVC9A0jEfWGReQnYq8IXes46fhq5uY24Z7aSAZ/ahSFbXVRCI
         83jg==
X-Gm-Message-State: APjAAAUWIo9X5eIXye91FIZDA2fg2XL8YNLm8GBA6QobjZUcy+gUJxNy
        2b5WYITbz9EXoaPmpFcux7skaYP/
X-Google-Smtp-Source: APXvYqxKfzi4gciNBtMzokOvWk0JFkOMuVI7XVtuSzOtqG/prlXxoUIZXMSFLDb/jhTL8zRn5+x1hA==
X-Received: by 2002:a1c:9991:: with SMTP id b139mr10652514wme.53.1555076317028;
        Fri, 12 Apr 2019 06:38:37 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x205sm11594682wmg.9.2019.04.12.06.38.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Apr 2019 06:38:36 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 26/30] tools/lib/traceevent: Man page for tep_parse_header_page()
Date:   Fri, 12 Apr 2019 16:38:07 +0300
Message-Id: <20190412133811.15878-27-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190412133811.15878-1-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man page for tep_parse_header_page() libtraceevent API.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-parse_head.txt              | 82 +++++++++++++++++++
 1 file changed, 82 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-parse_head.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-parse_head.txt b/tools/lib/traceevent/Documentation/libtraceevent-parse_head.txt
new file mode 100644
index 000000000000..c90f16c7d8e6
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-parse_head.txt
@@ -0,0 +1,82 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_parse_header_page - Parses the data stored in the header page.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_parse_header_page*(struct tep_handle pass:[*]_tep_, char pass:[*]_buf_, unsigned long _size_, int _long_size_);
+--
+
+DESCRIPTION
+-----------
+The _tep_parse_header_page()_ function parses the header page data from _buf_,
+and initializes the _tep_, trace event parser context, with it. The buffer
+_buf_ is with _size_, and is supposed to be copied from
+tracefs/events/header_page.
+
+Some old kernels do not have header page info, in this case the
+_tep_parse_header_page()_ function  can be called with _size_ equal to 0. The
+_tep_ context is initialized with default values. The _long_size_ can be used in
+this use case, to set the size of a long integer to be used.
+
+RETURN VALUE
+------------
+The _tep_parse_header_page()_ function returns 0 in case of success, or -1
+in case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+char *buf;
+int size;
+buf = read_file("/sys/kernel/tracing/events/header_page", &size);
+if (tep_parse_header_page(tep, buf, size, sizeof(unsigned long)) != 0) {
+	/* Failed to parse the header page */
+}
+...
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


Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ADA3C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55EB12087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfCHNhf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:35 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46381 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfCHNhe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:34 -0500
Received: by mail-wr1-f66.google.com with SMTP id i16so21376183wrs.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L1IWRStKn+CgkAIQku139tVPIQjflwlXSBx2hL5Nh3Q=;
        b=RRo/CSDqg+Scuh42muQray2XoS0+lYHlf7k9PZ7CBpF0CINXEm3gBlXB62zlw9kEQU
         ooALqWQjZQWvzbGqlUDF3O/sNdgRUd6vDFxG9sL2sYF1SRNr8zWRWHFqyF7FXzaAjBQX
         Z5FBiukNiV1DkCGSgWehpFd9NhznteiNit7yMAOFKkzLNTKU/Kx11j0Nc0SobCvmthj/
         CA4mibuyB3/bs65xJ3gRgb7ZQS6r5WcPy3NIp1AMHpyzSEIa0gJdib3cUaA7eRFC2T44
         tf/FpxrZAF/55GE59axDwK4VGvNCvgBQ6rz02UKQBsxA/4eX/+UoDds5ufK5wNISX+lF
         9ECw==
X-Gm-Message-State: APjAAAUwh/uDiTS9Q3L4w1LIydSnOEo5wglLqWoDpTOW54AJzpBD7fPj
        W1ziaJYtQKnLDOgLt8DIiuc=
X-Google-Smtp-Source: APXvYqx5PCeL7hqkWi1IHGOwh+goa575eXnJzjC+6prtzEzz/4yFZxFLhZQfGHHv36arGNBVkDJ62g==
X-Received: by 2002:adf:f711:: with SMTP id r17mr2901834wrp.38.1552052253009;
        Fri, 08 Mar 2019 05:37:33 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:32 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 38/46] tools/lib/traceevent: Man page for tep_parse_header_page()
Date:   Fri,  8 Mar 2019 15:36:46 +0200
Message-Id: <20190308133654.21264-39-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man page for tep_parse_header_page()
as part of the libtraceevent APIs.

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


Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56AACC10F09
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31FF52087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfCHNhQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:16 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33399 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbfCHNhP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:15 -0500
Received: by mail-wm1-f67.google.com with SMTP id c13so8984321wmb.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eUjE/wYu/1U5ZRiq54tMRYFe7F7Xz+Ev8qBdR8EHe7w=;
        b=deViBxmgWxeolBYU9sPFamgVdEgc+xWEPaxIZ0DMVuQViB+xMFbSIsRwPRm4I2JKXh
         0W6/U0/lb5FrdsVljniSQK6bOEFvROH0glStokU8N8UdP/1fwjfd6DIkZdV5hZL4KlZ8
         jUE13IjlIbVkMv72gP4DbvMhArnf6UNmoU3tioPCOiAn4Hs+RFRsPZKdxk3fyPKB2Gef
         nY/ZOyMa8buHa54NKSX0hsnHhSZt55m+MtcWe8t3/U/pNFnrWndQJHzLeFr3xmK7BRD4
         gByfWnp6p91+CiIEZddrDIdKMGkcd1HR0g/rje3ubnoBGT3TCEWZ2oRcV1jDALEtohwq
         JNig==
X-Gm-Message-State: APjAAAUlJUXolV35NcNLosVgQadY1Gg+rMkCFeaVJeYR/MtlRwOCbHdE
        wYSyU+wRTQrV5dwLc5ZK5sAzmCTL
X-Google-Smtp-Source: APXvYqzGNKCF8uSF5xzlmLxDPt4/TnD0wNwb6uH1akjlT0lALQwC9WX1zxvWqc+uIq9MEd7wPtPvEg==
X-Received: by 2002:a05:600c:210b:: with SMTP id u11mr9197988wml.11.1552052233677;
        Fri, 08 Mar 2019 05:37:13 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:12 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 17/46] tools/lib/traceevent: Man page for tep_read_number()
Date:   Fri,  8 Mar 2019 15:36:25 +0200
Message-Id: <20190308133654.21264-18-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man page for tep_read_number() as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-endian_read.txt             | 76 +++++++++++++++++++
 1 file changed, 76 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-endian_read.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-endian_read.txt b/tools/lib/traceevent/Documentation/libtraceevent-endian_read.txt
new file mode 100644
index 000000000000..803819dbf51b
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-endian_read.txt
@@ -0,0 +1,76 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_read_number - Reads a number from raw data.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+unsigned long long *tep_read_number*(struct tep_handle pass:[*]_tep_, const void pass:[*]_ptr_, int _size_);
+--
+
+DESCRIPTION
+-----------
+The _tep_read_number()_ function reads an integer from raw data, taking into
+account the endianness of the raw data and the current host. The _tep_ argument
+is the trace event parser context. The _ptr_ is a pointer to the raw data, where
+the integer is, and the _size_ is the size of the integer.
+
+RETURN VALUE
+------------
+The _tep_read_number()_ function returns the integer in the byte order of
+the current host. In case of an error, 0 is returned.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+void process_record(struct tep_record *record)
+{
+	int data = tep_read_number(tep, record->data, 4);
+	/* Read the first 4 bytes of the record as integer */
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


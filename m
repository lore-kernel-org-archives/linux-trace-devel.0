Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A94FCC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 835AB2087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfCHNhK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:10 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35457 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfCHNhK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:10 -0500
Received: by mail-wm1-f65.google.com with SMTP id y15so12489355wma.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dZKEN8D78d3miwdOGcgg5ljNlQPfFAEZrEh6coCZn6k=;
        b=K0UqIdHIniDLaD0sSrIcSgRrbNPp9w0aKizOU2UE2peyqhBcdTsnTFv0e0xlvF4hdX
         DOt5MAO2Gu4OSmyCMeJ5cQkjmcGkW87vUVXDA6qMM0oxnzSNcPCcKnfrw/46x8ZypBoz
         0Yj/Pp2bF9u1jCReoUPv9Gjpbs31P0wntiFfltWdHTqU2UM0M5FLJ4eb394gAUBdeSwU
         7x/V+DEX9CPruu382J/YtoJzVpCuTJZz+ynxi6ucIcpWu1mzUc6mR5/XHHAh8QtqMTsw
         VWDXbuLmjImgxOGajJmnTNMd8+3fgsQ2M2prrYJh0Ix59lCgRPoX1njmXDYBucUhCbCB
         yiEw==
X-Gm-Message-State: APjAAAXe12nYjG0yQjxULJMDd4DCOZrTfA4t8KSwIxRTfGWPIT0TbAmD
        E5Rs2IlZx2KKPfiSxw8sgrq/ims8
X-Google-Smtp-Source: APXvYqzxN63gAcqkkDwaA6Y5tSNXyfKAd34DpmE7pmT7F06TkhAN7YGvLycqoj6Sgr1PNFg9d+ssVg==
X-Received: by 2002:a7b:c41a:: with SMTP id k26mr9752834wmi.6.1552052227966;
        Fri, 08 Mar 2019 05:37:07 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:07 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 11/46] tools/lib/traceevent: Man page for tep_get_page_size() and tep_set_page_size()
Date:   Fri,  8 Mar 2019 15:36:19 +0200
Message-Id: <20190308133654.21264-12-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for tep_get_page_size() and tep_set_page_size()
as part of the libtraceevent APIs. It also alignes description of
the functions (in the C code) with the man pages.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-page_size.txt | 80 +++++++++++++++++++
 1 file changed, 80 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-page_size.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-page_size.txt b/tools/lib/traceevent/Documentation/libtraceevent-page_size.txt
new file mode 100644
index 000000000000..0701001fffcf
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-page_size.txt
@@ -0,0 +1,80 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_get_page_size,tep_set_page_size - Get / set the size of a memory page on the
+machine, where the trace is generated
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_get_page_size*(struct tep_handle pass:[*]_tep_);
+void *tep_set_page_size*(struct tep_handle pass:[*]_tep_, int _page_size_);
+--
+
+DESCRIPTION
+-----------
+The _tep_get_page_size()_ function returns the size of a memory page on
+the machine, where the trace is generated. The _tep_ argument is trace
+event parser context.
+
+The _tep_set_page_size()_ function stores in the _tep_ context the size of a
+memory page on the machine, where the trace is generated.
+The _tep_ argument is trace event parser context.
+The _page_size_ argument is the size of a memory page, in bytes.
+
+RETURN VALUE
+------------
+The _tep_get_page_size()_ function returns size of the memory page, in bytes.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+	int page_size = 4096;
+	tep_set_page_size(tep, page_size);
+	if ( 4096 != tep_get_page_size(tep)) {
+		/* Something wrong happened, page size is not set as expected */
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


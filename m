Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6F2CC4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3AE92087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbfCHNh2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:28 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51441 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfCHNh2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:28 -0500
Received: by mail-wm1-f68.google.com with SMTP id n19so12556535wmi.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wnWrGzQARiX1s+dRisL2DZot2ArWd/j/DpLT54yarC4=;
        b=DEnBxIlyldMo5D1GdkLof9/KvAwXUpoDUsH55KvjX+mrLeyypNYrW/mVbIYlAggnvF
         KrZKExoVuBb/bVpZxBThqjE1tuaUf+rAtgvNyVa1ugFiFN+gPQs5Yd7WWezrfTiANCK/
         F4JV6d7PaIVt34HYT2L4nsKBrdVTGGL56zv8gWjYMOkXqpV1HslCqwBiGJUwTbqt7hbd
         jZM0YTNQ5XnBf/GEqQqkA0UoSwCBSBJRl99GMDpUlIFuhTODcwuo710ZVDNFqCR5LyLF
         PrxI/y2JOuURsfHz7UdRp+w/M6O/zqqs+qe9aOj845By+UOcgLTeM2qbDNCiwspa4CL7
         cGiw==
X-Gm-Message-State: APjAAAVBUP8Cupf+NrHvAlaA+VSJ0ZFctS5mjuLkLl+HogIVxdaAeJAY
        95AdMSvsxEezQVE60ESlwEzsL+Wn
X-Google-Smtp-Source: APXvYqxfFx7vN/6xrekCOl9f2WF28FNuiVEnyw25uocW/bXEo0Ldulxo1mVEFxiWZFRd2OahjLuMFw==
X-Received: by 2002:a1c:6305:: with SMTP id x5mr7657677wmb.144.1552052246443;
        Fri, 08 Mar 2019 05:37:26 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:25 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 31/46] tools/lib/traceevent: Man page for tep_filter_match()
Date:   Fri,  8 Mar 2019 15:36:39 +0200
Message-Id: <20190308133654.21264-32-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man page for tep_filter_match()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-filter_match.txt            | 96 +++++++++++++++++++
 1 file changed, 96 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter_match.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-filter_match.txt b/tools/lib/traceevent/Documentation/libtraceevent-filter_match.txt
new file mode 100644
index 000000000000..af5e6d2a5986
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-filter_match.txt
@@ -0,0 +1,96 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_filter_match - Tests if a record matches a filter.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+enum tep_errno *tep_filter_match*(struct tep_event_filter pass:[*]_filter_, struct tep_record pass:[*]_record_);
+--
+
+DESCRIPTION
+-----------
+The _tep_filter_match()_ function tests if a _record_ matches given _filter_.
+
+RETURN VALUE
+------------
+The _tep_filter_match()_ function returns _tep_errno_, according to the result:
+[verse]
+--
+_pass:[TEP_ERRNO__FILTER_MATCH]_	- filter found for event, the record matches.
+_pass:[TEP_ERRNO__FILTER_MISS]_		- filter found for event, the record does not match.
+_pass:[TEP_ERRNO__FILTER_NOT_FOUND]_	- no filter found for record's event.
+_pass:[TEP_ERRNO__NO_FILTER]_		- no rules in the filter.
+--
+or any other _tep_errno_, if an error occurred during the test.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+struct tep_event_filter *filter = tep_filter_alloc(tep);
+...
+void process_record(struct tep_record *record)
+{
+	switch (tep_filter_match(filter, record)) {
+	case TEP_ERRNO__FILTER_MATCH:
+		/* The filter matches the record */
+		break;
+	case TEP_ERRNO__FILTER_MISS:
+		/* The filter does not match the record */
+		break;
+	case TEP_ERRNO__FILTER_NOT_FOUND:
+		/* No filter found for record's event */
+		break;
+	case TEP_ERRNO__NO_FILTER:
+		/* There are no rules in the filter */
+		break
+	default:
+		/* An error occurred during the test */
+		break;
+	}
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


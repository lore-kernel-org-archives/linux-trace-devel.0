Return-Path: <SRS0=scwk=TD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADBEDC04AAA
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88D4F206C3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbfECJL2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 May 2019 05:11:28 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36059 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbfECJL2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 May 2019 05:11:28 -0400
Received: by mail-wr1-f68.google.com with SMTP id o4so6904407wra.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 May 2019 02:11:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7bejhqSWNJ6yrsYhJqtY8KvJICS0zi1EcjABl3JOxyQ=;
        b=n2PTRKEu6dzu7zBqXjxl1Hvi4UepvY/0ecxHJ5A6a5jiM47c6azZmj5uKtKr134CvC
         G0WPvsuIJA4xZVj+cIS4bczeLukhk3OvDXQnvm+adPm880EVygwNVflv1jbpJoIu/gQc
         JTMnf9PW20SYAt/v83jLBfNansw7arB2u3ty1rftKO8v3BMgmJ/MYErUJe0jDlmac8IO
         j5pb/RZHNaoe69t4pG6mzB3Inm3XxYnkBpYeOnWX1dJ3wDDd85r8Ro20LFHg6j2fk+Pg
         yKPU0OmDR95dLJ9s4kLtvhSnjDodpcqandsad08pes5w1ee3pjFRiEHZ2m2Kwpup1XsH
         xc3A==
X-Gm-Message-State: APjAAAW89eKbREDgjQDdE76rrbD7+uRL4qOpV/3BTtN2nbaDoiJAZ/en
        5Bn9nDPJHVvBQHWTMrhhR+w/MrcN
X-Google-Smtp-Source: APXvYqyRAv8x+dX8GW7dVUoGp6PAyqOIbmyv0yhPEiRkyoZIgvQts6etY2uWoJKsADKNHErwOzAgwA==
X-Received: by 2002:a05:6000:1201:: with SMTP id e1mr6358021wrx.49.1556874686556;
        Fri, 03 May 2019 02:11:26 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id b11sm2398596wmh.29.2019.05.03.02.11.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 02:11:26 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 06/26] tools/lib/traceevent: Man page for file endian APIs
Date:   Fri,  3 May 2019 12:10:59 +0300
Message-Id: <20190503091119.23399-7-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503091119.23399-1-tstoyanov@vmware.com>
References: <20190503091119.23399-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for libtraceevent APIs:
  tep_is_file_bigendian(),
  tep_set_file_bigendian()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-file_endian.txt             | 91 +++++++++++++++++++
 1 file changed, 91 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt b/tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt
new file mode 100644
index 000000000000..f401ad311047
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt
@@ -0,0 +1,91 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_is_file_bigendian, tep_set_file_bigendian - Get / set the endianness of the
+raw data being accessed by the tep handler.
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
+bool *tep_is_file_bigendian*(struct tep_handle pass:[*]_tep_);
+void *tep_set_file_bigendian*(struct tep_handle pass:[*]_tep_, enum tep_endian _endian_);
+
+--
+DESCRIPTION
+-----------
+The _tep_is_file_bigendian()_ function gets the endianness of the raw data,
+being accessed by the tep handler. The _tep_ argument is trace event parser
+context.
+
+The _tep_set_file_bigendian()_ function sets the endianness of raw data being
+accessed by the tep handler. The _tep_ argument is trace event parser context.
+[verse]
+--
+The _endian_ argument is the endianness:
+	_TEP_LITTLE_ENDIAN_ - the raw data is in little endian format,
+	_TEP_BIG_ENDIAN_ - the raw data is in big endian format.
+--
+RETURN VALUE
+------------
+The _tep_is_file_bigendian()_ function returns true if the data is in bigendian
+format, false otherwise.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+	tep_set_file_bigendian(tep, TEP_LITTLE_ENDIAN);
+...
+	if (tep_is_file_bigendian(tep)) {
+		/* The raw data is in big endian */
+	} else {
+		/* The raw data is in little endian */
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


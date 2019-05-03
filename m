Return-Path: <SRS0=scwk=TD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0275C43219
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB51A206C3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbfECJL3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 May 2019 05:11:29 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55793 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbfECJL3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 May 2019 05:11:29 -0400
Received: by mail-wm1-f66.google.com with SMTP id y2so5858192wmi.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 May 2019 02:11:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E9vt/G/DyNCdWLgRQJPQIBL7aO506BRCRf057OJgGtE=;
        b=MOBq1zL4fOHKcITr65ek4g8LtVPQ9VXm23ORHbF0qCClRVybTpm566hIwUWWpIqY+Y
         pyfZ75JAZNsFIv1d5HaN1SH9DI/pAMRs154A1xcz7yoHG9kIMPUwxzyM6taNi1IoV3dT
         hluFVFrG4v319v35f2KiYNMTAHH9NSspOZOdoDmPZupjW7wlgZfdkuc4SmjzBReSoBOi
         RN0XafZ1wiscHsslG8hBYfQGppXDDXgWGdx4EvI3xp3LNqAGhZBLS0z49l/qc2axzpBM
         1H5FiIW5hPB7Qc2L+pSC9EkH0mSz5EKzYUseybFytACzfaualMvNKulWCNpCqAh3B4iD
         5yxw==
X-Gm-Message-State: APjAAAX4Dz2rLD4LM18/FgOh7SaXEgOLJciVAXqpJPEGhH5e6x5m8DkJ
        CoDw8KRIFCSwUTWdy2NjNxM=
X-Google-Smtp-Source: APXvYqzht9nu13MWHtghQZ7D6/rVm7sRh6HgVDvkTJpT3LFqytC00goiFeEsoY+cHI3w1usBE6E6DQ==
X-Received: by 2002:a1c:a753:: with SMTP id q80mr5489428wme.120.1556874687748;
        Fri, 03 May 2019 02:11:27 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id b11sm2398596wmh.29.2019.05.03.02.11.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 02:11:26 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 07/26] tools/lib/traceevent: Man page for host endian APIs
Date:   Fri,  3 May 2019 12:11:00 +0300
Message-Id: <20190503091119.23399-8-tstoyanov@vmware.com>
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
  tep_is_bigendian(),
  tep_is_local_bigendian(),
  tep_set_local_bigendian()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-host_endian.txt             | 104 ++++++++++++++++++
 1 file changed, 104 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-host_endian.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-host_endian.txt b/tools/lib/traceevent/Documentation/libtraceevent-host_endian.txt
new file mode 100644
index 000000000000..d5d375eb8d1e
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-host_endian.txt
@@ -0,0 +1,104 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_is_bigendian, tep_is_local_bigendian, tep_set_local_bigendian - Get / set
+the endianness of the local machine.
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
+int *tep_is_bigendian*(void);
+bool *tep_is_local_bigendian*(struct tep_handle pass:[*]_tep_);
+void *tep_set_local_bigendian*(struct tep_handle pass:[*]_tep_, enum tep_endian _endian_);
+--
+
+DESCRIPTION
+-----------
+
+The _tep_is_bigendian()_ gets the endianness of the machine, executing
+the function.
+
+The _tep_is_local_bigendian()_ function gets the endianness of the local
+machine, saved in the _tep_ handler. The _tep_ argument is the trace event
+parser context. This API is a bit faster than _tep_is_bigendian()_, as it
+returns cached endianness of the local machine instead of checking it each time.
+
+The _tep_set_local_bigendian()_ function sets the endianness of the local
+machine in the _tep_ handler. The _tep_ argument is trace event parser context.
+The _endian_ argument is the endianness:
+[verse]
+--
+	_TEP_LITTLE_ENDIAN_ - the machine is little endian,
+	_TEP_BIG_ENDIAN_ - the machine is big endian.
+--
+
+RETURN VALUE
+------------
+The _tep_is_bigendian()_ function returns non zero if the endianness of the
+machine, executing the code, is big endian and zero otherwise.
+
+The _tep_is_local_bigendian()_ function returns true, if the endianness of the
+local machine, saved in the _tep_ handler, is big endian, or false otherwise.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+	if (tep_is_bigendian())
+		tep_set_local_bigendian(tep, TEP_BIG_ENDIAN);
+	else
+		tep_set_local_bigendian(tep, TEP_LITTLE_ENDIAN);
+...
+	if (tep_is_local_bigendian(tep))
+		printf("This machine you are running on is bigendian\n");
+	else
+		printf("This machine you are running on is little endian\n");
+
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


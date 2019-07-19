Return-Path: <SRS0=Y6Oh=VQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6E35C76196
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Jul 2019 22:50:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD83121883
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Jul 2019 22:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbfGSWuc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Jul 2019 18:50:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732346AbfGSWub (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Jul 2019 18:50:31 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8035D21880;
        Fri, 19 Jul 2019 22:50:31 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hobhu-0000N5-K7; Fri, 19 Jul 2019 18:50:30 -0400
Message-Id: <20190719225030.507227790@goodmis.org>
User-Agent: quilt/0.65
Date:   Fri, 19 Jul 2019 18:46:16 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Josef Bacik <jbacik@fb.com>,
        Darren Hart <dvhart@infradead.org>, troyengel@gmail.com
Subject: [PATCH 3/3] trace-cmd: Use PyLong_AsLong() for Python 3
References: <20190719224613.207069107@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Python 3 has deprecated PyInt_AS_LONG. Add code to use PyLong_AsLong() if
Python 3 is detected. As Python 2 is going to be EOL soon, we need to
support Python 3.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204231

Reported-by: Troy Engel <troyengel@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 python/ctracecmd.i | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/python/ctracecmd.i b/python/ctracecmd.i
index 63e5dcb813f1..2601d39a76be 100644
--- a/python/ctracecmd.i
+++ b/python/ctracecmd.i
@@ -117,14 +117,21 @@ static PyObject *py_field_get_stack(struct tep_handle *pevent,
 	return list;
 }
 
+#if PY_MAJOR_VERSION >= 3
 static PyObject *fromMemory(void *buf, size_t len)
 {
-#if PY_MAJOR_VERSION >= 3
 		return PyMemoryView_FromMemory(buf, len, PyBUF_READ);
+}
+#define PY_INT_AS_LONG PyLong_AsLong
 #else
+static PyObject *fromMemory(void *buf, size_t len)
+{
 		return PyBuffer_FromMemory(buf, len);
-#endif
 }
+#define PY_INT_AS_LONG PyInt_AS_LONG
+#endif
+
+
 
 static PyObject *py_field_get_data(struct tep_format_field *f, struct tep_record *r)
 {
@@ -226,7 +233,7 @@ static int python_callback(struct trace_seq *s,
 			Py_XDECREF(result);
 			return 0;
 		}
-		r = PyInt_AS_LONG(result);
+		r = PY_INT_AS_LONG(result);
 	} else if (result == Py_None)
 		r = 0;
 	else
-- 
2.20.1



Return-Path: <SRS0=Y6Oh=VQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D353C76195
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Jul 2019 22:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8BEA21883
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Jul 2019 22:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732346AbfGSWuc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Jul 2019 18:50:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732337AbfGSWuc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Jul 2019 18:50:32 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36E4F20873;
        Fri, 19 Jul 2019 22:50:31 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hobhu-0000M0-9j; Fri, 19 Jul 2019 18:50:30 -0400
Message-Id: <20190719225030.187908166@goodmis.org>
User-Agent: quilt/0.65
Date:   Fri, 19 Jul 2019 18:46:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Josef Bacik <jbacik@fb.com>,
        Darren Hart <dvhart@infradead.org>, troyengel@gmail.com
Subject: [PATCH 1/3] trace-cmd: Replace PySting_FromString() with PyUnicode_FromString()
References: <20190719224613.207069107@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Python 3 has deprecated PyString_FromString(), but both Python 2 and
Python 3 have PyUnicode_FromString() which should be equivalent (at least
according to google). As Python 2 is going to be EOL soon, we need to
support Python 3.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204231

Reported-by: Troy Engel <troyengel@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 python/ctracecmd.i | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/python/ctracecmd.i b/python/ctracecmd.i
index 65a3d5144b88..09d1d6414fc1 100644
--- a/python/ctracecmd.i
+++ b/python/ctracecmd.i
@@ -108,7 +108,7 @@ static PyObject *py_field_get_stack(struct tep_handle *pevent,
 		    ((int)addr == -1))
 			break;
 		func = tep_find_function(event->tep, addr);
-		if (PyList_Append(list, PyString_FromString(func))) {
+		if (PyList_Append(list, PyUnicode_FromString(func))) {
 			Py_DECREF(list);
 			return NULL;
 		}
@@ -162,10 +162,10 @@ static PyObject *py_field_get_str(struct tep_format_field *f, struct tep_record
 		 */
 		offset = val & 0xffff;
 
-		return PyString_FromString((char *)r->data + offset);
+		return PyUnicode_FromString((char *)r->data + offset);
 	}
 
-	return PyString_FromStringAndSize((char *)r->data + f->offset,
+	return PyUnicode_FromStringAndSize((char *)r->data + f->offset,
 				strnlen((char *)r->data + f->offset, f->size));
 }
 
@@ -177,7 +177,7 @@ static PyObject *py_format_get_keys(struct tep_event *ef)
 	list = PyList_New(0);
 
 	for (f = ef->format.fields; f; f = f->next) {
-		if (PyList_Append(list, PyString_FromString(f->name))) {
+		if (PyList_Append(list, PyUnicode_FromString(f->name))) {
 			Py_DECREF(list);
 			return NULL;
 		}
-- 
2.20.1



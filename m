Return-Path: <SRS0=vwbJ=VW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECCE7C76190
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 19:28:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3361218EA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 19:28:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfGYT2g convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 15:28:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726597AbfGYT2g (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 15:28:36 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EDC7218DA;
        Thu, 25 Jul 2019 19:28:35 +0000 (UTC)
Date:   Thu, 25 Jul 2019 15:28:32 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Patrick McLean <chutzpah@gentoo.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/3] trace-cmd: in python plugin, use
 PyUnicode_FromString on Python 3
Message-ID: <20190725152832.134251d1@gandalf.local.home>
In-Reply-To: <20190725140409.1012b9dc@gandalf.local.home>
References: <20190725174138.3724131-1-chutzpah@gentoo.org>
        <20190725174138.3724131-2-chutzpah@gentoo.org>
        <20190725140409.1012b9dc@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 25 Jul 2019 14:04:09 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> > --- a/plugins/plugin_python.c
> > +++ b/plugins/plugin_python.c
> > @@ -81,7 +81,11 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
> >  	} else
> >  		Py_DECREF(res);
> >  
> > +#if PY_MAJOR_VERSION >= 3
> > +	str = PyUnicode_FromString("pevent");
> > +#else
> >  	str = PyString_FromString("pevent");
> > +#endif  
> 
> I believe using just PyUnicode_FromString() will work for both v2 and
> v3. That's what I did in my other patches.

FYI, I applied this instead:

-- Steve

From ccca93c8f24b66beea1d68b7207e8de1ede8d108 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Thu, 25 Jul 2019 15:20:10 -0400
Subject: [PATCH] trace-cmd: Replace PyString_FromString() with
 PyUnicode_FromString()

As PyString_FromString() is no longer available with Python 3, use
PyUnicode_FromString() which is available in both Python 2 and 3.

Link: http://lkml.kernel.org/r/20190725174138.3724131-2-chutzpah@gentoo.org

Reported-by: Patrick McLean <patrick.mclean@sony.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 plugins/plugin_python.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/plugins/plugin_python.c b/plugins/plugin_python.c
index e725ad84..196b8256 100644
--- a/plugins/plugin_python.c
+++ b/plugins/plugin_python.c
@@ -81,7 +81,7 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 	} else
 		Py_DECREF(res);
 
-	str = PyString_FromString("pevent");
+	str = PyUnicode_FromString("pevent");
 	if (!str)
 		return -ENOMEM;
 
-- 
2.20.1


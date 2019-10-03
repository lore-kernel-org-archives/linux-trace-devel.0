Return-Path: <SRS0=xFsM=X4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1161FC4360C
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Oct 2019 00:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D83EA222BE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Oct 2019 00:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbfJCAMb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Oct 2019 20:12:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfJCAMb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Oct 2019 20:12:31 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6E0B222BE;
        Thu,  3 Oct 2019 00:12:30 +0000 (UTC)
Date:   Wed, 2 Oct 2019 20:12:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 5/5] trace-cmd: Add initial infrastructure for
 trace-cmd specific plugins.
Message-ID: <20191002201229.1b96751a@gandalf.local.home>
In-Reply-To: <20191002114152.30048-6-tz.stoyanov@gmail.com>
References: <20191002114152.30048-1-tz.stoyanov@gmail.com>
        <20191002114152.30048-6-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  2 Oct 2019 14:41:52 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

>  
> -$(LIBTRACEEVENT_SHARED): force $(obj)/lib/traceevent/plugins/traceevent_plugin_dir
> +$(LIBTRACEEVENT_SHARED): force $(obj)/lib/traceevent/plugins/python_dir \
> +			 $(obj)/lib/traceevent/plugins/traceevent_plugin_dir
>  	$(Q)$(MAKE) -C $(src)/lib/traceevent $@
>  
> -$(LIBTRACEEVENT_STATIC): force $(obj)/lib/traceevent/plugins/traceevent_plugin_dir
> +$(LIBTRACEEVENT_STATIC): force $(obj)/lib/traceevent/plugins/python_dir \
> +			 $(obj)/lib/traceevent/plugins/traceevent_plugin_dir
>  	$(Q)$(MAKE) -C $(src)/lib/traceevent $@
>  
>  $(LIBTRACECMD_STATIC): force
> @@ -290,13 +301,22 @@ libtracecmd.so: $(LIBTRACECMD_SHARED)
>  
>  libs: $(LIBTRACECMD_SHARED) $(LIBTRACEEVENT_SHARED)
>  
> -plugins: force $(obj)/lib/traceevent/plugins/traceevent_plugin_dir $(obj)/lib/traceevent/plugins/trace_python_dir
> +plugins_traceevent: force $(obj)/lib/traceevent/plugins/traceevent_plugin_dir \
> +		   $(obj)/lib/traceevent/plugins/python_dir
>  	$(Q)$(MAKE) -C $(src)/lib/traceevent/plugins
>  

Hmm, I'm getting this:

$ make
make[1]: *** No rule to make target '/work/git/trace-cmd.git/lib/traceevent/plugins/python_dir'.  Stop.
make: *** [Makefile:320: /work/git/trace-cmd.git/lib/traceevent/plugins/python_dir] Error 2

It works if I manually create the missing python_dir.

-- Steve

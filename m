Return-Path: <SRS0=14DL=SR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E11AC10F0E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 20:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D86520854
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 20:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbfDOUEl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 16:04:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:57718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728530AbfDOUEk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 16:04:40 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F00F42070D;
        Mon, 15 Apr 2019 20:04:39 +0000 (UTC)
Date:   Mon, 15 Apr 2019 16:04:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Slavomir Kaslev <kaslevs@vmware.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/4] kernel-shark: Configuration information in
 ${HOME}/.cache/kernelshark
Message-ID: <20190415160438.785c389a@gandalf.local.home>
In-Reply-To: <30661ef4-5fc5-d362-3df3-09fb1cc54482@gmail.com>
References: <20190404145603.13592-1-ykaradzhov@vmware.com>
        <20190404145603.13592-2-ykaradzhov@vmware.com>
        <20190408150102.GA6430@box>
        <20190408111308.301f30c1@gandalf.local.home>
        <0808d774-880a-f232-dda3-cd897120d86d@gmail.com>
        <20190409092349.3e7cb6e3@gandalf.local.home>
        <CAE0o1NtOBbVGjHfYyqOhrCrmywSNjYWOprDU66uMTPx4hX4UGA@mail.gmail.com>
        <20190409111100.28297adb@gandalf.local.home>
        <CAE0o1Nv_JgHpTHgwpLhw7dkyxqW_u-rRUBMojgzPENCwVUDbmg@mail.gmail.com>
        <30661ef4-5fc5-d362-3df3-09fb1cc54482@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 15 Apr 2019 14:16:53 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> I still think that if you build KernelShark from source, the most 
> natural  default path for the open-file dialogs is the 
> trace-cmd/kernel-shark directory. However if this directory doesn't 
> exist the dialogs can start at ${HOME} (the one of the user running the 
> app).

What you can do, and this is what some other applications do, is to
check the relative path of the binary. There's a few ways to accomplish
this. But once you know the exact path that the application ran from,
you can then check if the plugins exist relatively to the executable.

> 
> 
> I still think that if you build KernelShark from source, the most 
> natural  default path for the open-file dialogs is the 
> trace-cmd/kernel-shark directory. However if this directory doesn't 
> exist {distro installation} the dialogs can start at ${HOME} (the one of 
> the user running the app).


If I run kernelshark via:

 kernelshark/bin/kernelshark

that full path name will be in argv[0].

If I run it as: ./kernelshark we can look at that too. Perhaps we
should only check this if it's executed by a local path name (that is,
if it is found via the $PATH variable, we don't do this), which would
be the case if argv[0] == "kernelshark" and not "./kernelshark" or
something like that.

That is, we have something like this:

	if (strstr(argv[0], "/")) {
		char *fullpath = strdup(argv[0]);
		char *path, *local_plugin_path;
		struct stat sb;

		if (!fullpath) die(...);
		path = dirname(fullpath);
		ret = asprintf(&local_plugin_path, "%s/../../plugins");
		if (!ret) die (...);
		ret = stat(local_plugin_path, &sb);
		if (!ret) {
			if ((sb.st_mode & S_IFMT) == S_IFDIR)
				use_local_plugin_path = true;
		}
		free(fullpath);
		free(local_plugin_path);
	}

That way if you run this from the source directory, we use the source
plugin files, otherwise, we use the default ones.

-- Steve

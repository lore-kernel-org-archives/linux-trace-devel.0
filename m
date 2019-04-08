Return-Path: <SRS0=kFh5=SK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FFA0C10F13
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 15:13:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BFCB2148E
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 15:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfDHPNK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 11:13:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726228AbfDHPNK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 11:13:10 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 995E8214C6;
        Mon,  8 Apr 2019 15:13:09 +0000 (UTC)
Date:   Mon, 8 Apr 2019 11:13:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/4] kernel-shark: Configuration information in
 ${HOME}/.cache/kernelshark
Message-ID: <20190408111308.301f30c1@gandalf.local.home>
In-Reply-To: <20190408150102.GA6430@box>
References: <20190404145603.13592-1-ykaradzhov@vmware.com>
        <20190404145603.13592-2-ykaradzhov@vmware.com>
        <20190408150102.GA6430@box>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 8 Apr 2019 18:01:03 +0300
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> > +++ b/Makefile
> > @@ -254,7 +254,10 @@ all_cmd: $(CMD_TARGETS)
> >  CMAKE_COMMAND = /usr/bin/cmake
> >  
> >  $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
> > -	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -D_INSTALL_PREFIX=$(prefix) ..
> > +
> > +	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) \
> > +		-D_KS_CACHE_DIR=$(HOME)/.cache/kernelshark \  
>                                 ^
> Which $HOME would that be? The one for the user who built kernelshark and not the user who runs it.
> 
> 
> > +		-D_INSTALL_PREFIX=$(prefix) ..

Correct, this needs to be the HOME from the run time environment. Which
is taken as the third parameter from main!

#include <stdio.h>
#include <string.h>
int main(int argc, char **argv, **envp)
{
	int i;
	for (i = 0; env[i]; i++) {
		if (strncmp(env[i], "HOME=", 5) == 0)
			printf("home is %s\n", env[i] + 5);
	}
	return 0;
}


-- Steve

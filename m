Return-Path: <SRS0=9Wso=3L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9782EC2D0DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 17:22:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78D8721835
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 17:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgAVRWJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 12:22:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:52994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgAVRWJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 12:22:09 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AA0621835;
        Wed, 22 Jan 2020 17:22:08 +0000 (UTC)
Date:   Wed, 22 Jan 2020 12:22:06 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH 3/5] trace-cmd: Add installation of ld.conf.d file for
 library paths
Message-ID: <20200122122206.07595a4d@gandalf.local.home>
In-Reply-To: <20200122171329.340613663@goodmis.org>
References: <20200122171250.252248737@goodmis.org>
        <20200122171329.340613663@goodmis.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 22 Jan 2020 12:12:53 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> diff --git a/scripts/utils.mk b/scripts/utils.mk
> index d1d5135063fc..4da8829159a0 100644
> --- a/scripts/utils.mk
> +++ b/scripts/utils.mk
> @@ -133,3 +133,11 @@ define do_install_data
>  	fi;						\
>  	$(INSTALL) -m 644 $1 '$(DESTDIR_SQ)$2'
>  endef
> +
> +define do_install_ld
> +	$(print_install)				\

Hmm, the print should only happen inside the if.

> +	if [ -d '$(DESTDIR_SQ)$2' ]; then		\

Bah, I fixed this if statement but applied it to another commit.

Will post a v2.

-- Steve

> +		echo '$3' >> $(DESTDIR_SQ)$2/$1;	\
> +		ldconfig;				\
> +	fi
> +endef


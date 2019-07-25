Return-Path: <SRS0=vwbJ=VW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFFDEC76190
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 18:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0D3B229F3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 18:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbfGYSEM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 14:04:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbfGYSEM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 14:04:12 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92C46229F3;
        Thu, 25 Jul 2019 18:04:11 +0000 (UTC)
Date:   Thu, 25 Jul 2019 14:04:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Patrick McLean <chutzpah@gentoo.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/3] trace-cmd: in python plugin, use
 PyUnicode_FromString on Python 3
Message-ID: <20190725140409.1012b9dc@gandalf.local.home>
In-Reply-To: <20190725174138.3724131-2-chutzpah@gentoo.org>
References: <20190725174138.3724131-1-chutzpah@gentoo.org>
        <20190725174138.3724131-2-chutzpah@gentoo.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 25 Jul 2019 10:41:36 -0700
Patrick McLean <chutzpah@gentoo.org> wrote:

> From: Patrick McLean <patrick.mclean@sony.com>
> 
> All strings are unicode in Python 3, so PyString_* is no longer
> reccommended. This uses PyUnicode_* instead.
> 
> Signed-off-by: Patrick McLean <patrick.mclean@sony.com>
> ---
>  plugins/plugin_python.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/plugins/plugin_python.c b/plugins/plugin_python.c
> index e725ad8..dc7932e 100644
> --- a/plugins/plugin_python.c
> +++ b/plugins/plugin_python.c
> @@ -81,7 +81,11 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
>  	} else
>  		Py_DECREF(res);
>  
> +#if PY_MAJOR_VERSION >= 3
> +	str = PyUnicode_FromString("pevent");
> +#else
>  	str = PyString_FromString("pevent");
> +#endif

I believe using just PyUnicode_FromString() will work for both v2 and
v3. That's what I did in my other patches.

-- Steve

>  	if (!str)
>  		return -ENOMEM;
>  


Return-Path: <SRS0=6oeL=TB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74DCBC43219
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 May 2019 01:38:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4972421743
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 May 2019 01:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfEABiT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Apr 2019 21:38:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbfEABiS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Apr 2019 21:38:18 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0FA42087B;
        Wed,  1 May 2019 01:38:17 +0000 (UTC)
Date:   Tue, 30 Apr 2019 21:38:16 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 27/30] tools/lib/traceevent: Man pages for tep
 plugins APIs
Message-ID: <20190430213816.61705657@oasis.local.home>
In-Reply-To: <20190412133811.15878-28-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
        <20190412133811.15878-28-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 12 Apr 2019 16:38:08 +0300
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> +DESCRIPTION
> +-----------
> +The _tep_load_plugins()_ function loads all plugins, located in the plugin
> +directories. The _tep_ argument is trace event parser context.
> +The plugin directories are :
> +[verse]
> +--
> +	- System's plugin directory, defined at the library compile time. It
> +	  depends on the library installation prefix and usually is
> +	  _(install_preffix)/lib/traceevent/plugins_
> +	- Directory, defined by the environment variable _TRACEEVENT_PLUGIN_DIR_
> +	- User's plugin directory, located at _~/.traceevent/plugins_

We should change this to be:

 ~/.config/traceevent/plugins/plugins_*.so

-- Steve

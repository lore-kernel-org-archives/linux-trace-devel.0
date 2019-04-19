Return-Path: <SRS0=h6jj=SV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3825FC282DA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 18:44:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E35B205C9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 18:44:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfDSSoP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:44:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbfDSSoP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Apr 2019 14:44:15 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2B17222D8;
        Fri, 19 Apr 2019 17:28:16 +0000 (UTC)
Date:   Fri, 19 Apr 2019 13:28:15 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com
Subject: Re: [PATCH v3 4/8] kernel-shark: Add logic for the plugins search
 path
Message-ID: <20190419132815.2820b6af@gandalf.local.home>
In-Reply-To: <20190419135036.19340-5-ykaradzhov@vmware.com>
References: <20190419135036.19340-1-ykaradzhov@vmware.com>
        <20190419135036.19340-5-ykaradzhov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 19 Apr 2019 16:50:32 +0300
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> +char *KsPluginManager::_pluginLibFromName(const QString &plugin, int &n)
> +{
> +	QString path = QCoreApplication::applicationFilePath();
> +	std::string pluginStr = plugin.toStdString();
> +	char *lib;
> +
> +	if (path.contains(KS_DIR)) {

I'd rather not use the hardcoded path. If I build the code on one
machine, tarball it up and move it to another machine and extract it,
and then run that code from that machine, I want it to still use the
plugins for that machine.

I was hoping to test:

	string = cmdline_path() + "../../kernel-shark/lib/";

If that exists, then we know that we are in the source directory.

-- Steve

> +		n = asprintf(&lib, "%s/lib/plugin-%s.so",
> +			     KS_DIR, pluginStr.c_str());
> +	} else {
> +		n = asprintf(&lib, "%s/lib/kshark/plugins/plugin-%s.so",
> +			     _INSTALL_PREFIX, pluginStr.c_str());
> +	}
> +
> +	return lib;
> +}
> +

Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9042C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 22:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BF6B23C83
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 22:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393072AbgLKVws (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 16:52:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:37980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406396AbgLKVwM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 16:52:12 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3087D23B31;
        Fri, 11 Dec 2020 21:51:08 +0000 (UTC)
Date:   Fri, 11 Dec 2020 16:51:06 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v7 18/32] kernel-shark: Complete the stream integration
Message-ID: <20201211165106.78f5c44d@gandalf.local.home>
In-Reply-To: <20201211150756.577366-19-y.karadz@gmail.com>
References: <20201211150756.577366-1-y.karadz@gmail.com>
        <20201211150756.577366-19-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


> +/**
> + * Register to the data stream all default plugins for FTRACE (trace-cmd) data.
> + */
> +int kshark_tep_handle_plugins(struct kshark_context *kshark_ctx, int sd)
> +{
> +	int i, n_tep_plugins = ARRAY_SIZE(tep_plugin_names);

Note, ARRAY_SIZE() isn't defined when this patch is applied, and the build
fails.

-- Steve


> +	struct kshark_plugin_list *plugin;
> +	struct kshark_data_stream *stream;
> +
> +	stream = kshark_get_data_stream(kshark_ctx, sd);
> +	if (!stream)
> +		return -EEXIST;
> +
> +	for (i = 0; i < n_tep_plugins; ++i) {
> +		plugin = kshark_find_plugin_by_name(kshark_ctx->plugins,
> +						    tep_plugin_names[i]);
> +
> +		if (plugin && plugin->process_interface) {
> +			kshark_register_plugin_to_stream(stream,
> +							 plugin->process_interface,
> +							 true);
> +		} else {
> +			fprintf(stderr, "Plugin \"%s\" not found.\n",
> +				tep_plugin_names[i]);
> +		}
> +	}
> +
> +	return kshark_handle_all_dpis(stream, KSHARK_PLUGIN_INIT);
> +}
> +

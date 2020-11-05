Return-Path: <SRS0=ZY51=EL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B3DC388F7
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Nov 2020 19:22:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2B8920867
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Nov 2020 19:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731740AbgKETW4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Nov 2020 14:22:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:39974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730973AbgKETW4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Nov 2020 14:22:56 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AFEC2078E;
        Thu,  5 Nov 2020 19:22:55 +0000 (UTC)
Date:   Thu, 5 Nov 2020 14:22:53 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 20/20] kernel-shark: Integrate streams with
 libkshark-configio
Message-ID: <20201105142253.69485d76@gandalf.local.home>
In-Reply-To: <20201012133523.469040-21-y.karadz@gmail.com>
References: <20201012133523.469040-1-y.karadz@gmail.com>
        <20201012133523.469040-21-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 12 Oct 2020 16:35:23 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> +int kshark_import_trace_file(struct kshark_context *kshark_ctx,
> +			     struct kshark_config_doc *conf)
>  {
> -	const char *file = NULL;
> +	const char *file = NULL, *name = NULL;
> +	int sd = -1;
> +
>  	switch (conf->format) {
>  	case KS_CONFIG_JSON:
> -		if (kshark_trace_file_from_json(&file, conf->conf_doc))
> -			kshark_open(kshark_ctx, file);
> +		if (kshark_trace_file_from_json(&file, &name, "data",
> +						conf->conf_doc)) {
> +			if (strcmp(name, "top") == 0) {

Is "top" something that could be named by a user? That is, we could have a
conflict if a buffer is called "top"?

If this is a special meaning, then we should probably make this something A
user can not do, or even better, unlikely to have. And we shouldn't have it
hardcoded as "top" anyway, it should be a macro.


#define KERNEL_SHARK_TOP_STREAM		"/ / / __Top__ / / /"

Then everywhere use that.

Like in kshark_tep_init_input():

	stream->name = strdup(KERNEL_SHARK_TOP_STREAM);

And also replace "top" in this code with that macro as well.

-- Steve


> +				sd = kshark_open(kshark_ctx, file);
> +			} else {
> +				int sd_top;
> +
> +				sd_top = kshark_tep_find_top_stream(kshark_ctx,
> +								    file);
> +				if (sd_top < 0) {
> +					/*
> +					 * The "top" steam (buffer) has to be
> +					 * initialized first.
> +					 */
> +					sd_top = kshark_open(kshark_ctx, file);
> +				}
> +
> +				if (sd_top >= 0)
> +					sd = kshark_tep_open_buffer(kshark_ctx,
> +								    sd_top,
> +								    name);
> +
> +				if (sd >= 0)
> +				kshark_tep_handle_plugins(kshark_ctx, sd);
> +			}
> +		}
> +
> +		break;
>  
> +	default:
> +		fprintf(stderr, "Document format %d not supported\n",
> +			conf->format);
>  		break;
> +	}
> +
> +	return sd;
> +}

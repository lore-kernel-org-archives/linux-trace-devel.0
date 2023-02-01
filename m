Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92AD6C38142
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 Feb 2023 19:25:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbjBATZi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 1 Feb 2023 14:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbjBATZh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Feb 2023 14:25:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5DF383051;
        Wed,  1 Feb 2023 11:25:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62E2AB8228B;
        Wed,  1 Feb 2023 19:25:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32AF5C433D2;
        Wed,  1 Feb 2023 19:25:32 +0000 (UTC)
Date:   Wed, 1 Feb 2023 14:25:30 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        linux-trace-devel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/6] rtla/osnoise: Add helper functions to manipulate
 osnoise/options
Message-ID: <20230201142530.61b5ac00@gandalf.local.home>
In-Reply-To: <930c4ef71c7bcb1158d2a8cad905f4de425b8d1e.1675181734.git.bristot@kernel.org>
References: <cover.1675181734.git.bristot@kernel.org>
        <930c4ef71c7bcb1158d2a8cad905f4de425b8d1e.1675181734.git.bristot@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 31 Jan 2023 17:30:02 +0100
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> +#define	OSNOISE_OPTION(name, option_str)						\
> +static int osnoise_get_##name(struct osnoise_context *context)				\
> +{											\
> +	if (context->opt_##name != OSNOISE_OPTION_INIT_VAL)				\
> +		return context->opt_##name;						\
> +											\
> +	if (context->orig_opt_##name != OSNOISE_OPTION_INIT_VAL)			\
> +		return context->orig_opt_##name;					\
> +											\
> +	context->orig_opt_##name = osnoise_options_get_option(option_str);		\
> +											\
> +	return context->orig_opt_##name;						\
> +}											\
> +											\

What you could have done is not make this into a super macro (as there's
only one instance of it). And then add a patch that turns it into this
macro as the first patch of a series that adds another user.

Because I don't understand why this exists when it only has one user.

-- Steve

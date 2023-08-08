Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF23C001B0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Aug 2023 20:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233924AbjHHUY4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 16:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234937AbjHHUYc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 16:24:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3554D1EF73
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Aug 2023 12:35:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C165962B8B
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Aug 2023 19:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB5CC433C7;
        Tue,  8 Aug 2023 19:35:49 +0000 (UTC)
Date:   Tue, 8 Aug 2023 15:35:47 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH v3 1/6] histograms: Initial histograms interface
Message-ID: <20230808153547.29b7bc60@gandalf.local.home>
In-Reply-To: <20230808161204.5704-2-stevie.6strings@gmail.com>
References: <20230808161204.5704-1-stevie.6strings@gmail.com>
        <20230808161204.5704-2-stevie.6strings@gmail.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  8 Aug 2023 12:11:54 -0400
Stevie Alvarez <stevie.6strings@gmail.com> wrote:

> +/*
> + * Trace data entry for a traceeval histogram
> + * Constitutes keys and values.
> + */
> +union traceeval_data {
> +	char				*string;

We need to also add:

	const char			*cstring;

At least for the user interface, as I'm converting task-eval over to this,
and I need to assign const strings to this union.

-- Steve

> +	struct traceeval_dynamic	*dyn_data;
> +	unsigned long long		number_64;
> +	unsigned long			number;
> +	unsigned int			number_32;
> +	unsigned short			number_16;
> +	unsigned char			number_8;
> +};
> +

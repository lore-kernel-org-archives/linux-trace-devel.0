Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2716C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Nov 2022 00:06:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiKJAGq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Nov 2022 19:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbiKJAGl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Nov 2022 19:06:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C51717AA3
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Nov 2022 16:06:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 275E2B80959
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Nov 2022 00:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460B7C433C1;
        Thu, 10 Nov 2022 00:06:37 +0000 (UTC)
Date:   Wed, 9 Nov 2022 19:06:34 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Valentin Schneider <vschneid@redhat.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Douglas RAILLARD <douglas.raillard@arm.com>
Subject: Re: [PATCH 1/2] libtraceevent: Add boiler-plate code for cpumask
 types
Message-ID: <20221109190634.1fd9200d@rorschach.local.home>
In-Reply-To: <20221018151630.1513535-2-vschneid@redhat.com>
References: <20221018151630.1513535-1-vschneid@redhat.com>
        <20221018151630.1513535-2-vschneid@redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 18 Oct 2022 16:16:29 +0100
Valentin Schneider <vschneid@redhat.com> wrote:

> @@ -3484,6 +3498,11 @@ process_function(struct tep_event *event, struct tep_print_arg *arg,
>  		free_token(token);
>  		return process_bitmask(event, arg, tok);
>  	}
> +	if (strcmp(token, "__get_cpumask") == 0 ||
> +	    strcmp(token, "__get_cpumask") == 0) {

Hmm, not sure what the difference between the above two are.

-- Steve

> +		free_token(token);
> +		return process_cpumask(event, arg, tok);
> +	}
>  	if (strcmp(token, "__get_dynamic_array") == 0 ||
>  	    strcmp(token, "__get_rel_dynamic_array") == 0 ||
>  	    strcmp(token, "__get_sockaddr") == 0 ||

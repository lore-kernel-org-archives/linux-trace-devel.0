Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79D43C433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 May 2021 13:47:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 432CD610FB
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 May 2021 13:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbhEENsW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 5 May 2021 09:48:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:35036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229559AbhEENsW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 May 2021 09:48:22 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75E2C610FB
        for <linux-trace-devel@vger.kernel.org>; Wed,  5 May 2021 13:47:25 +0000 (UTC)
Date:   Wed, 5 May 2021 09:47:23 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/2] libtracefs: Add tracefs_event_enable/disable() API
Message-ID: <20210505094723.630adcc6@gandalf.local.home>
In-Reply-To: <20210505134248.3583391-2-rostedt@goodmis.org>
References: <20210505134248.3583391-1-rostedt@goodmis.org>
        <20210505134248.3583391-2-rostedt@goodmis.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 5 May 2021 09:42:47 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> +static int event_enable_disable(struct tracefs_instance *instance,
> +				const char *system, const char *event,
> +				bool enable)
> +{
> +	regex_t system_re, event_re;
> +	char **systems;
> +	char **events = NULL;
> +	int ret = -1;
> +	int s, e;
> +
> +	/* Handle all events first */
> +	if (!system && !event)
> +		return enable_disable_all(instance, enable);
> +
> +	systems = tracefs_event_systems(NULL);
> +	if (!systems)
> +		goto out_free;
> +
> +	if (system) {
> +		ret = regcomp(&system_re, system, REG_ICASE|REG_NOSUB);
> +		if (ret < 0)
> +			goto out_free;
> +	}
> +	if (event) {
> +		ret = regcomp(&event_re, event, REG_ICASE|REG_NOSUB);
> +		if (ret < 0) {
> +			if (system)
> +				regfree(&system_re);
> +			goto out_free;
> +		}
> +	}
> +
> +	for (s = 0; systems[s]; s++) {
> +		if (system && !match(systems[s], &system_re))
> +			continue;
> +
> +		/* Check for the short cut first */
> +		if (!event) {
> +			ret = enable_disable_system(instance, systems[s], enable);
> +			if (ret < 0)
> +				break;
> +			ret = 0;
> +			continue;
> +		}
> +
> +		events = tracefs_system_events(NULL, systems[s]);
> +		if (!events)
> +			continue; /* Error? */
> +
> +		for (e = 0; events[e]; e++) {
> +			if (!match(events[e], &event_re))
> +				continue;
> +			ret = enable_disable_event(instance, systems[s],
> +						   events[e], enable);
> +			if (ret < 0)
> +				break;
> +			ret = 0;
> +		}
> +		tracefs_list_free(events);
> +		events = NULL;
> +	}

Bah, I need to free both the system and event regex here.

Will send v2.

-- Steve

> +
> + out_free:
> +	tracefs_list_free(systems);
> +	tracefs_list_free(events);
> +	return ret;
> +}

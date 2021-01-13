Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09321C43333
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Jan 2021 02:11:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD245235F8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Jan 2021 02:11:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729281AbhAMWQn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Jan 2021 17:16:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:43142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729205AbhAMWOj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Jan 2021 17:14:39 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1B5F23136;
        Wed, 13 Jan 2021 22:13:48 +0000 (UTC)
Date:   Wed, 13 Jan 2021 17:13:47 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 5/6] trace-cmd library man pages: Manage trace session
 with multiple trace peers.
Message-ID: <20210113171347.1e75f7a6@gandalf.local.home>
In-Reply-To: <20201223043429.586162-6-tz.stoyanov@gmail.com>
References: <20201223043429.586162-1-tz.stoyanov@gmail.com>
        <20201223043429.586162-6-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


I'm assuming that you can pair multiple guests with a single host?

That is, can we have:


	bool g1 = false, g2 = false;

	host = tracecmd_open_head("trace.dat");
	tracecmd_init_data(host);
	guest1 = tracecmd_open_head("trace-Guest-1.dat");
	guest2 = tracecmd_open_head("trace-Guest-2.dat");

	guest_id_1 = tracecmd_get_traceid(guest1);
	guest_id_2 = tracecmd_get_traceid(guest1);

	if (!tracecmd_get_guest_cpumap(host, guest_id_1, &name1, &vcount1, &cpu_pids1)
		g1 = !tracecmd_init_data(guest1);

	if (!tracecmd_get_guest_cpumap(host, guest_id_2, &name2, &vcount2, &cpu_pids2)
		g2 = !tracecmd_init_data(guest2);

	if (g1) {
		int i;
		for (i = 0; i < vcount1; i++) {
			printf("Host task id %d maps to guest %s cpu %d\n",
				cpu_pids1[i], name1, i);
		}
		tracecmd_unpair_peer(guest1);
	}

	if (g2) {
		int i;
		for (i = 0; i < vcount2; i++) {
			printf("Host task id %d maps to guest %s cpu %d\n",
				cpu_pids2[i], name2, i);
		}
		tracecmd_unpair_peer(guest2);
	}

And use something like the above for the example?

-- Steve


On Wed, 23 Dec 2020 06:34:28 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <trace-cmd.h>
> +...
> +struct tracecmd_input *host = tracecmd_open_head("trace.dat");
> +	if (!host) {
> +		/* Failed to open host trace file */
> +	}
> +	tracecmd_init_data(host);
> +
> +struct tracecmd_input *guest = tracecmd_open_head("trace-Guest.dat");
> +	if (!guest) {
> +		/* Failed to open guest trace file */
> +	}
> +
> +unsigned long long guest_id = tracecmd_get_traceid(guest);
> +int *cpu_pid;
> +char *name;
> +int vcount;
> +
> +	if (!tracecmd_get_guest_cpumap(host, guest_id, &name, &vcount, &cpu_pid)) {
> +		/* The Host and a guest with name was part of the same trace session.
> +		 * Got guest VCPU to host PID mapping.
> +		 */
> +		if (!tracecmd_pair_peer(guest, host)) {
> +			/* Successfully paired host to the guest handler */
> +			tracecmd_init_data(guest);
> +			...
> +			tracecmd_unpair_peer(guest);
> +		}
> +	}
> +
> +...
> +	tracecmd_close(guest);
> +	tracecmd_close(hadle);
> +
> +--

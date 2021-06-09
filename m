Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81990C48BCF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Jun 2021 17:00:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63C92613C8
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Jun 2021 17:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhFIRCP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Jun 2021 13:02:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230205AbhFIRCO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Jun 2021 13:02:14 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 106B76139A;
        Wed,  9 Jun 2021 17:00:19 +0000 (UTC)
Date:   Wed, 9 Jun 2021 13:00:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 4/4] libtracefs: Propagate the return value of the
 callback function
Message-ID: <20210609130018.2dd877ef@oasis.local.home>
In-Reply-To: <20210608135503.12135-4-y.karadz@gmail.com>
References: <20210608135503.12135-1-y.karadz@gmail.com>
        <20210608135503.12135-4-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

[ Sending again, but this time with "Reply-all" to include the mailing list ]

On Tue,  8 Jun 2021 16:55:03 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Currently the return value of the callback function can be used to
> stop pulling data from the trace buffer, however this return value
> is lost and the user has no idea if tracefs_iterate_raw_events()
> terminated because there was no more data or because this was
> requested from the callback function. If we propagate the return
> value of the callback, this can be used in cases like the one below:
> 
> int callback(struct tep_event *event, struct tep_record *record,
> 	     int cpu, void *py_func)
> {
> 	....
> 
> 	return (something) ? 0 : 1
> }
> 
> int main()
> {
> 	int ret;
> 
> 	....
> 
> 	while(ret == 0)
> 		ret = tracefs_iterate_raw_events(tep, instance,
> 		                                 NULL, 0,
> 		                                 callback, NULL);
> 
> 	....
> 
> Here the user can effectively terminate the pulling the data
> from inside the callback.

With this change, the user can't tell if returned -1 due to an error or
because the callback ended early, (which is not considered an error).

The proper way for an application to handle this, is to pass in a
context structure, and have the callback set a value if it exits early
or not. I've done this already for needing the same information.

No change to libtracefs is needed. This functionality is already
available with the current design:

struct my_struct {
	bool	stopped;
};

int callback(struct tep_event *event, struct tep_record *record,
		    int cpu, void *data)
{
	struct my_struct *my_data = data;

	[..]
	if (condition) {
		my_data->stopped = true;
		return 1;
	}
	return 0;
}

int main()
{
	struct my_struct my_data = { .stopped = false };
	int ret = 0;

	while (!ret && !my_data.stopped)
		ret = tracefs_iterate_raw_events(tep, instance, NULL, 0,
					callback, &my_data);
}

Now, if you are using this within python, and you want the python
wrapper to pass data as well, you just need to add that to the struct:

struct my_struct {
	bool		stopped;
	func		*python_callback;
	void		*python_data;
}

int callback(struct tep_event *event, struct tep_record *record,
		    int cpu, void *data)
{
	struct my_struct *my_data = data;
	int ret;

	[..]
	ret = my_data->python_callback(event, record, cpu, data->python_data);

	if (ret) {
		my_data->stopped = true;
		return 1;
	}
	return 0;
}

int python_iterator(pthyon_callback, python_data)
{
	struct my_struct my_data = { .stopped = false };
	int ret = 0;

	my_data.python_data = python_data;
	my_data.python_callback = python_callback;

	while (!ret && !my_data.stopped)
		ret = tracefs_iterate_raw_events(tep, instance, NULL, 0,
					callback, &my_data);
}

So this patch isn't needed.

-- Steve

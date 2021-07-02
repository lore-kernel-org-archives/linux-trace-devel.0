Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF80EC11F6B
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 11:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD02961425
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 11:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbhGBLgG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Jul 2021 07:36:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231976AbhGBLgF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Jul 2021 07:36:05 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E8C661422;
        Fri,  2 Jul 2021 11:33:33 +0000 (UTC)
Date:   Fri, 2 Jul 2021 07:33:32 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 1/7] libtracefs: Implement tracefs_instances()
Message-ID: <20210702073332.357ca775@rorschach.local.home>
In-Reply-To: <4335f4d8-73eb-a2e4-f439-95cbe69acff2@gmail.com>
References: <20210702035443.154729-1-rostedt@goodmis.org>
        <20210702035443.154729-2-rostedt@goodmis.org>
        <4335f4d8-73eb-a2e4-f439-95cbe69acff2@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 2 Jul 2021 14:10:46 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> > +static int build_list(const char *name, void *data)
> > +{
> > +	struct instance_list *list = data;
> > +	char **instances;
> > +	int ret = -1;
> > +
> > +	if (!match(name, list->re))
> > +		return 0;
> > +
> > +	instances = realloc(list->list, list->size + 2);
> > +	if (!instances)
> > +		goto out;
> > +
> > +	list->list = instances;  
> Hi Steven,
> 
> I am not sure what was your original intention here, but this doesn't 
> seem to work properly. Maybe we need something like this:
> 
> 	int size =  sizeof(*instances) * (list->size + 2);
> 	instances = realloc(list->list, size);

Bah, that's what I get for trying to "multitask" while coding :-p
That was suppose to be:

	instances = realloc(list->list, sizeof(*instances) * (list->size + 2);

as you stated, but I'll keep it one line.

> 	if (!instances)
> 		goto out;
> 
> 	instances[list->size + 1] = NULL;
> 
> 
> 
> 
> > +	list->list[list->size] = strdup(name);
> > +	if (!list->list[list->size])
> > +		goto out;
> > +
> > +	list->size++;
> > +	ret = 0;
> > +
> > + out:
> > +	list->failed = ret;
> > +	return ret;
> > +}
> > +
> > +/**
> > + * tracefs_instances - return a list of instance names
> > + * @regex: A regex of instances to filter on (NULL to match all)
> > + *
> > + * Returns a list of names of existing instances, that must be
> > + * freed with tracefs_list_free(). Note, if there are no matches
> > + * then an empty list will be returned (not NULL).
> > + * NULL on error.
> > + */
> > +char **tracefs_instances(const char *regex)
> > +{
> > +	struct instance_list list = { .re = NULL, .list = NULL };
> > +	regex_t re;
> > +	int ret;
> > +
> > +	if (regex) {
> > +		ret = regcomp(&re, regex, REG_ICASE|REG_NOSUB);
> > +		if (ret < 0)
> > +			return NULL;
> > +		list.re = &re;
> > +	}
> > +
> > +	ret = tracefs_instances_walk(build_list, &list);
> > +	if (ret < 0 || list.failed) {
> > +		tracefs_list_free(list.list);
> > +		list.list = NULL;
> > +	} else {
> > +		if (!list.list) {
> > +			/* No matches should produce an empty list */
> > +			list.list = malloc(sizeof(*list.list));
> > +			if (list.list)
> > +				list.list[0] = NULL;
> > +		}  
> 
> Or you can just do:
> 				return calloc(1, sizeof(*list.list));

Which I do in tracefs_get_probes(), must have missed this one.

Will update, thanks for the review.


-- Steve


> 
> Thanks!
> Yordan
> 
> > +	}
> > +	return list.list;
> > +}

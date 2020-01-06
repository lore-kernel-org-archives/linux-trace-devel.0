Return-Path: <SRS0=UiB3=23=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1306C33C8C
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 16:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72CB8222D9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 16:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgAFQa3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 11:30:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:53192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbgAFQa3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 11:30:29 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BAB3208C4;
        Mon,  6 Jan 2020 16:30:28 +0000 (UTC)
Date:   Mon, 6 Jan 2020 11:30:26 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Ideals for tep plugin options
Message-ID: <20200106113026.75893f92@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Tzvetomir,

I was looking at the plugin options, and I believe it needs to be
updated.

1) the tep_plugin_option structure:

  - rename "file" to "plugin"
  - remove "plugin_alias"

2) Currently we have the following plugin option functions exported in
trace-cmd:

 char **tep_plugin_list_options(void);
 void tep_plugin_free_options_list(char **list);
 int tep_plugin_add_options(const char *name,
			   struct tep_plugin_option *options);
 int tep_plugin_add_option(const char *name, const char *val);
 void tep_plugin_remove_options(struct tep_plugin_option *options);
 void tep_plugin_print_options(struct trace_seq *s);
 void tep_print_plugins(struct trace_seq *s,
			const char *prefix, const char *suffix,
			const struct tep_plugin_list *list);

What we should only have is:

 int tep_plugin_add_options(const char *plugin,
			  struct tep_plugin_option *options);
 int tep_plugin_set_option(const char *plugin, const char *name,
			  const char *val);
 int tep_plugin_remove_options(struct tep_plugin_option *options);
 struct tep_plugin_option const * const tep_plugin_options_list(void);


Where:

  tep_plugin_add_options() is basically the same as we have now. But we
    should change it so that if "plugin" is already registered, it
    should fail with -EBUSY.

 tep_plugin_set_option() lets us update the option. If "plugin" is
   NULL, then it will ignore that value, and will set all options with
   "name" to "val", regardless of what plugin it belongs to.

 tep_plugin_remove_options() is basically the same as what we have now,
   and removes the options from the list.

 tep_plugin_options_list() returns an immutable list of all the
   registered plugin options. This is the list that the application can
   use to see what options are registered, as well as their default
   (and current) values.

Does this make sense?

-- Steve

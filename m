Return-Path: <SRS0=PkBc=KX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:33950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726733AbeHHOxC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Aug 2018 10:53:02 -0400
Date: Wed, 8 Aug 2018 08:33:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH 2/2] kernel-shark-qt: Add Json I/O for filter
 configurations.
Message-ID: <20180808083330.1373ce9b@gandalf.local.home>
In-Reply-To: <ced0da66-0b65-b45b-037a-370fd07a16db@gmail.com>
References: <20180807160013.11537-1-y.karadz@gmail.com>
        <20180807160013.11537-2-y.karadz@gmail.com>
        <20180807212126.0fe0fbe7@gandalf.local.home>
        <ced0da66-0b65-b45b-037a-370fd07a16db@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 8 Aug 2018 14:48:53 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> On  8.08.2018 04:21, Steven Rostedt wrote:
> >> +
> >> +	/* Create a Json array and fill the Id values into it. */
> >> +	jfilter_data = json_object_new_array();
> >> +	if (!jfilter_data)  
> > Hmm, can json_object_put() take a NULL pointer?
> >   
> 
> Yes, see here:
> 
> https://github.com/json-c/json-c/blob/master/json_object.c#L185
> 

Sadly they don't appear to document this fact :-/

 http://json-c.github.io/json-c/json-c-0.12/doc/html/json__object_8h.html#a1bb50e2d17832c404c3d5f13fbde5bf5

-- Steve

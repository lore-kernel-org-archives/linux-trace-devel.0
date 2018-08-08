Return-Path: <SRS0=PkBc=KX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:33750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbeHHOvu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Aug 2018 10:51:50 -0400
Date: Wed, 8 Aug 2018 08:32:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH 2/2] kernel-shark-qt: Add Json I/O for filter
 configurations.
Message-ID: <20180808083219.642bbb71@gandalf.local.home>
In-Reply-To: <f176f271-74c1-ecb0-1592-beb77e25e8e8@gmail.com>
References: <20180807160013.11537-1-y.karadz@gmail.com>
        <20180807160013.11537-2-y.karadz@gmail.com>
        <20180807212126.0fe0fbe7@gandalf.local.home>
        <f176f271-74c1-ecb0-1592-beb77e25e8e8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 8 Aug 2018 14:48:10 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Hi Steven,
> 
> On  8.08.2018 04:21, Steven Rostedt wrote:
> >> /**
> >> + * @brief Create an empty Json document and set its type description.
> >> + *
> >> + * @param type: String describing the type of the document,
> >> + *		e.g. "kshark.record.config" or "kshark.filter.config".
> >> + *
> >> + * @returns json_object instance. Use json_object_put() to free the object.  
> > I wonder if we should add handlers like:
> > 
> > 	kshark_config_free(struct json_object *jobj);
> > 
> > and call that instead? Perhaps even create our own object that may
> > contain extra state that the json object does not, and return that?
> > 
> >   
> 
> What do we gain by doing it this way?
> 

   CONTROL!!!!! :-) :-)


But seriously, if we had our own abstraction for the json objects, we
could carry extra data along with it if need be. In fact, we could
abstract out completely that we use json. We could just add our own
wrappers, and if some day in the future, something else comes along
that's better than json, we could switch to that.

I'm not strongly committed to doing this abstraction, but I want us to
think about it before we commit to anything. Like I said, forward
compatibility is the difficult part. I don't know exactly how this is
all going to end up being used, but I like to keep my options open.

-- Steve

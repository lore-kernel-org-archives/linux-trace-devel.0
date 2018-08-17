Return-Path: <SRS0=xGmm=LA=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:46882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbeHQPz4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Aug 2018 11:55:56 -0400
Date: Fri, 17 Aug 2018 08:52:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] kernel-shark-qt: Add I/O for configuration data.
Message-ID: <20180817085235.0de3493a@gandalf.local.home>
In-Reply-To: <102a7b39-3eeb-0e00-9e1a-39578d178ece@gmail.com>
References: <20180816150729.4680-1-y.karadz@gmail.com>
        <20180816150729.4680-2-y.karadz@gmail.com>
        <20180816145219.7e91e435@gandalf.local.home>
        <102a7b39-3eeb-0e00-9e1a-39578d178ece@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 17 Aug 2018 12:34:27 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Hi Steven,
> 
> On 16.08.2018 21:52, Steven Rostedt wrote:
> >> +/**
> >> + * @brief Check the type of a Configuration document and compare with an
> >> + *	  expected value.
> >> + *
> >> + * @param conf: Input location for the kshark_config_doc instance.
> >> + * @param type: Input location for the expected value of the Configuration
> >> + *		document type, e.g. "kshark.record.config" or
> >> + *		"kshark.filter.config".  
> > Oh, I forgot to ask...
> > 
> > Do you expect to have different "kshark.record" and kshark.filter"
> > options other than ".config"? If not, shouldn't it be:
> > 
> > 	"kshark.config.record" and "kshark.config.filter" ?
> > 
> > That way we can do searches for all the configs in a json file by
> > searching for "kshark.config".
> > 
> >   
> 
> My logic was that in the future we may have KernelShark doing some 
> automated analyses over the trace data. In this case the result can be 
> outputted to a Json file and have a type "kshark.*.output". So I 
> intuitively added the ".config" at the end, like a file extension.
> 
> However your logic makes sense and I am OK with switching the order.

Yes please. Naming like this is usually done in "reverse" language.
Similar to DNS names. Although we may type "www.vmware.com", it is
really processed in the order of "com:vmware:www". And with config
names, the more detailed the data, the farther out it goes:
 <domain>.<subdomain>.<topic>.<detailed_topic>

Thanks!

-- Steve

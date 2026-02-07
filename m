Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CE534C139
	for <linux-trace-devel@vger.kernel.org>; Sat,  7 Feb 2026 14:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770473777; cv=none; b=dYPA2uVvXf/8LxhjQNFgzcFKy0+3Bo5vzRySZv4GcttAFkwpI50wfnJlIbQm3Gi22k5Z2HWVRoEReiB97yCOe1q0kkZfye9Ozt0ZysSkSffa+X8E9CcRLR4TcVMU8ox7x6ISLZVdrknjdodJ6RVPrPU0meQPuh2joWqaAbVfDYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770473777; c=relaxed/simple;
	bh=xraN23MdfliuV4ElM0DwWQeJjhlbZjX6AovP/1wOFBM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mH5D5w7WmQs9opbYKmGu9Mn2wuC9KRr7MqsS65gpREBADYz/nmPYm+sbXAfpI9AefPdlhp15o6epFxfvX27uPIl28VCt5UzA3TJ/FtP5Sq7tGrbRmcBwEExhg9g0bxzMFZn01bBW6VzP/IbvT3sdQFPxQgAZdzDml68y8KSF5dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A96BD58E69;
	Sat,  7 Feb 2026 14:16:15 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf03.hostedemail.com (Postfix) with ESMTPA id E58DA6000A;
	Sat,  7 Feb 2026 14:16:13 +0000 (UTC)
Date: Sat, 7 Feb 2026 09:16:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Donglin Peng <dolinux.peng@gmail.com>
Cc: mhiramat@kernel.org, linux-trace-devel@vger.kernel.org, Donglin Peng
 <pengdonglin@xiaomi.com>
Subject: Re: [PATCH RESEND] libtraceevent: Pretty print function parameters
 of enum-type
Message-ID: <20260207091612.2bb72f61@robin>
In-Reply-To: <CAErzpmt8EQXD_noaR+gsBaAV90xAQSMJ38BgBd_8r-Q_40-abA@mail.gmail.com>
References: <20260206091512.2127246-1-dolinux.peng@gmail.com>
	<20260206100211.78193ec0@gandalf.local.home>
	<CAErzpmt8EQXD_noaR+gsBaAV90xAQSMJ38BgBd_8r-Q_40-abA@mail.gmail.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E58DA6000A
X-Stat-Signature: 7y3su3gozrewa3pi9mn11uamzeoahon9
X-Rspamd-Server: rspamout05
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18LRfI6+H9HO9xRrjNLBBBE7QOGJCfRfo4=
X-HE-Tag: 1770473773-464245
X-HE-Meta: U2FsdGVkX1+JTudDON6NjWYCIsiw4SkOtAXHk6KCvGLPUfu2Ruqu4QuEWPeKoUG9fEGt84PJZOzV6vUiszHFFj5Jg4T0+VvLPP8R8JVxkSWPYqbekaKf/j5Kygakk/LD/91lkFWLDKVz1/t8lxKGid4bJY91UQC9WU5s2WEWaV9GVRNbZ5h2K0y0J+cUDY6IBebc1mr+4jWhCZDBL1PjIrA7iNfYMQc0uyJn11Px1ApHQJx3ZLSwkmr1RsMqV2MKCvhp9guSKvAwGja6Rg/+3QQJGkbMU61oprWh0LEDEXP8ddHDT8dG5/P3jrnI8kZmqWn9oV4O+VKnUlnGbyujd+0Y7E14aFQm/OhT4DS6V9ZZ90+8sJL7JmS5HA8CaX5e

On Sat, 7 Feb 2026 13:04:02 +0800
Donglin Peng <dolinux.peng@gmail.com> wrote:

> > > +#define for_each_enum(i, enum_type, member)                  \
> > > +     for (i = 0, member = btf_enum(enum_type);               \
> > > +          i < BTF_INFO_VLEN(enum_type->info);                \
> > > +          i++, member++)  
> >
> >
> > You can make the above into:
> >
> >  #define for_each_enum(enum_type, member)                       \
> >         for (int __i = 0, member = btf_enum(enum_type);         \
> >              __i < BTF_INFO_VLEN((enum_type)->info);            \
> >              __i++, member++)
> >
> > Then you don't need to pass in the counter "i".  
> 
> Sorry, I found that the previous change causes a build failure.
> 
> The error occurs in trace-btf.c:36:
> warning: initialization of 'int' from 'struct btf_enum *' makes
> integer from pointer without a cast [-Wint-conversion]
>    36 |         for (int __i = 0, member = btf_enum(enum_type); \
> 
> This is due to the member variable being redefined as an int type,
> conflicting with its assignment of a struct btf_enum *pointer from
> btf_enum(enum_type).

Ah, I had that issue before. But this should work:

 #define for_each_enum(enum_type, member)				\
	member = btf_enum(enum_type);					\
	for (int __i = 0; __i < BTF_INFO_VLEN((enum_type)->info);	\
	     __i++, member++)

Just can't use it as a single line for if statements.

	if (x)
		for_each_enum() {
		}

But we shouldn't be doing that anyway.

-- Steve

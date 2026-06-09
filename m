Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4B8327C0D
	for <linux-trace-devel@vger.kernel.org>; Tue,  9 Jun 2026 15:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781018549; cv=none; b=Yx/ggRu8iNGTmElPGljAbqkL3bqJTugmvkm1OoHzB/cDE3p0ITtJVsko7H64MC+Vn1h7XPHwzdRcoSnSfs7wuXJrP+MCQrWn/zj3Zi0nbndTlsI9R0ND9mL6f6mNCmkoVY6D70MujZi3ZER7JfSoFCUX5X5PFkB/eIuZZgPStOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781018549; c=relaxed/simple;
	bh=9ZE/gF0Ec93yfGxtItXLQw4m9GnoD6lHmBZu34dSC2I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CIrHDAWhAsW+jqdEmcx93j+5wZeP3uSJMgBxKS9Qj1pYFOgcq/LhO3+9marqzpa+cDqn1kXuFcXhBYq/H6JQ7K8U9xQCwcXFdWOseKYXQrfuhf2AidSdll6qEPIHDNkWE5cZ5NhEOiyn1I2XQqJ/fxSSbBeVB1s87qPHlTdICP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 711711C2E55;
	Tue,  9 Jun 2026 15:22:26 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf04.hostedemail.com (Postfix) with ESMTPA id BE8A820030;
	Tue,  9 Jun 2026 15:22:24 +0000 (UTC)
Date: Tue, 9 Jun 2026 11:22:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <y.karadz@gmail.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
 helpdesk@kernel.org, Konstantin  Ryabitsev <mricon@kernel.org>
Subject: Re: Documentation update to KernelShark
Message-ID: <20260609112223.3a17b5ba@fedora>
In-Reply-To: <914607e6-1a51-e872-6383-292efecec61e@gmail.com>
References: <20260529115528.1d0f92a5@fedora>
	<914607e6-1a51-e872-6383-292efecec61e@gmail.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mq1p959wxq6k51mt3nbmhxqk17ms4mh4
X-Rspamd-Server: rspamout06
X-Rspamd-Queue-Id: BE8A820030
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/zjv2g1NN1N2QNFTSB6ef60wbp+hTTI7M=
X-HE-Tag: 1781018544-981175
X-HE-Meta: U2FsdGVkX1+FwipTRrUamVgTTOfSfkBkVctPJGKpgFQPRuXZHsP431nSM1hjm9FvRvChhS1Q4+2j0srQruaZX5wlh/hdoFgfiNS+BHAO1KdeWRB3piuEMurjE+VXf7DwQaUmu1qki6PWI9MiEvWqWG2qK7A7Lt7xhgImTkmUIr/aabUJ7b2FEPo5Os45EmlA6Sa1s8sQWChwEtGz2xRXowtPfnFJXfcRj3JmUDil4jTfTDbtph63gtEDvPaQEBTRxnuPPdP8S7MoDgULWJagWrXHJ42vbjBBqmlFNpqyT2UWPiLwx9HpQ3gmvsWZ5j8e4b+msR1EgmUO/lp0QjB+Q5a6c9ReoijYxXBZ+eC8CX9WSzFqSlIQVg==

On Thu, 4 Jun 2026 12:57:48 +0300
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> Hi Steven,
> 
> I am very happy to see a patch from you :-)
> 
> The patch has been applied to the repo.
> 
> I do have a PatchWork account. My username is ykaradzhov.

Hi Konstantin,

Is it possible to add Yordan's id to the list of possible "delegate to"
entries? This is for "Linux-Trace Development":

  https://patchwork.kernel.org/project/linux-trace-devel/list/

Thanks,

-- Steve


> 
> Cheers,
> Yordan
> 
> 
> On 5/29/26 18:55, Steven Rostedt wrote:
> > Hi Yordan,
> > 
> > Can you apply this patch to the  repo:
> > 
> >    https://patchwork.kernel.org/project/linux-trace-devel/patch/20251031115513.41b86970@gandalf.local.home/
> > 
> > Also, you probably should have your name added to the PatchWork so that
> > I can delegate KernelShark patches to you, and that will make it easier
> > for what is needed for KernelShark.
> > 
> > Do you have PatchWork account? If not, we should get you one (I Cc'd
> > helpdesk@kernel.org to let them know you need one too).
> > 
> > -- Steve  


Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E841D278161
	for <linux-trace-devel@vger.kernel.org>; Wed, 12 Nov 2025 20:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762981187; cv=none; b=cEsorMrfzRij3JsdLUcLxm4XARWNlV2uhcee8dMapqI1NWMGFp0+lOuLJ7AJeM/ZZq8dDx2PXA1U2rfRkzdgRtOMUwDnRpa7F9ODSUk1JjqKL3UrVNdtUx00vIf3QiuQSbPr1rC/SSqJDjwijSIstCIz+qXomW2c8Jk+88dThqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762981187; c=relaxed/simple;
	bh=jJs4OBlbXCwLO2VSYD9cOyQ0Un1nfWr/Lu202ou7Zng=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dQUfEV072XQsVMfdQG7bydmqwuB9lc1m/YX4tp+PIYERBsNsRDAiaIh5ubWf72VupjTVcTJcfJahthRg4+IjWVzY4H2g+jPlx3/hu+c2X1gyMni+HgiKRhjqxOwRpPudU4eRUhzFnlg9ikE558KrJ7AacInr3A6tuxYaWvOpsQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65AA2BA75C;
	Wed, 12 Nov 2025 20:59:43 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf12.hostedemail.com (Postfix) with ESMTPA id 76E871A;
	Wed, 12 Nov 2025 20:59:41 +0000 (UTC)
Date: Wed, 12 Nov 2025 15:59:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Douglas Raillard <douglas.raillard@arm.com>
Cc: linux-trace-devel@vger.kernel.org, Masami Hiramatsu
 <mhiramat@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Takaya Saeki
 <takayas@google.com>, Ian Rogers <irogers@google.com>, aahringo@redhat.com
Subject: Re: [PATCH 1/2] libtraceevent: Add loading of BTF to the tep handle
Message-ID: <20251112155954.234f00e5@gandalf.local.home>
In-Reply-To: <82376535-30a5-4602-aac7-1bd3abcd271a@arm.com>
References: <20250731185559.1644753-1-rostedt@goodmis.org>
	<20250731185559.1644753-2-rostedt@goodmis.org>
	<e74be108-7ca5-466e-a89a-512a80a11beb@arm.com>
	<20250804084322.15b8c321@gandalf.local.home>
	<82376535-30a5-4602-aac7-1bd3abcd271a@arm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 76E871A
X-Stat-Signature: ue6or37gd41hfn7sc3k7xadnkspzwaj7
X-Rspamd-Server: rspamout06
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+dFXbpsIwei20AwAnx5mhsDeHrlK4Gq6E=
X-HE-Tag: 1762981181-442248
X-HE-Meta: U2FsdGVkX18bJOaeH0QcbUHRFfTiJe+KMIrQTh+y8meKJPLn8JOP/DPG1hGkPs3rq7yF7qO5mr+RheXJ5G17jN2/R3PansM5J7XaJkTnT3x59fXPKs5I27iEo+MOgFpg4vHdd/T9Ua8xtz/bHTHabwlviKvQy2jY/n7mIJTyXJ5g3qg4TgfjNv0rLoydhLEdZlYipZbZL6UbwSxz4C/TGJIO36ldGYY6MzSkemmX/m2O0RzcztByrO7uM0yr0m/0NxkB4U9z+kQ2Lt6ECnRAjY4Pk5ui6S+Eawh0M2WS3FWTJyz55N9/3rtjMiIFzgibXU+o/suBGSLMaASZLGLp6mD1ZlcwyPYcPEI6nj2rY6tGbCZx3ZHRkzOLqQOWExWLcUAVojbTLH6rTIIXpZ+/JCKKKj2BJEDqco1shtxDSZx5OlVkVzZUMw==

On Mon, 4 Aug 2025 15:18:41 +0100
Douglas Raillard <douglas.raillard@arm.com> wrote:

> > 
> > You meant to the "arg" passed in?  
> 
> Yes, something like that:
> 
>    unsigned long long mask = (1 << BTF_INT_BITS(encode)) - 1;
>    unsigned long long shift = BTF_INT_OFFSET(encode);
>    arg = (arg >> shift) & mask;
> 
> I suppose that how BTF_INT_OFFSET() is to be used depends on endianness, and I'm not
> sure what is the endianness of the arg value. t->size would probably be involved as
> well in the big endian case: https://docs.kernel.org/bpf/btf.html#btf-kind-int

I implemented this and got a lot of BTF_INT_BITS(encode) = 0, where it
would not print anything. Then I realized this isn't really needed. Isn't
this for bit fields in a structure? How would bit size matter for function
parameters?

-- Steve

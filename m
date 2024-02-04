Received: from smtpout3.mo529.mail-out.ovh.net (smtpout3.mo529.mail-out.ovh.net [46.105.54.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C01250E2
	for <linux-trace-devel@vger.kernel.org>; Sun,  4 Feb 2024 19:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.105.54.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707074239; cv=none; b=rJYlroRMuJhFJFqfw7ueSLkMMyEjpwKwDQTzGh07X2HzrbAFhpVFY3vXb8jR+kk/1rI/akYz14+Kk4n/H3fKz8cPuS5+h2eVzVt+405prZ5xGxI3mXo6M/E9SLwRo6EpMKLAEFnWb7Jv1B7iwiWItQjDGpB5a/wiAqTfLHsM5hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707074239; c=relaxed/simple;
	bh=vPnJOw2jr6ucDSJJhCzD+W6PuVLQfqjGvPJNFSPk2dw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VfxW0r1jyX7fAU66XGY2L7Kfxx4WvA4omSCYPecXmUh2qkHvWHrPh4z3UNTMKkBkBM4rzr5q4fWnzYa+YskpNqAXklQfatIETVVo31yWqMYlIrKYUsN/ZD69gU7vxAFGXbJ1aGgNjenm1P9anf8hJoGqL5946JdgRivTLPBD+NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr; spf=pass smtp.mailfrom=benjarobin.fr; arc=none smtp.client-ip=46.105.54.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.109.139.122])
	by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 4922E20469;
	Sun,  4 Feb 2024 18:59:10 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.99) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 4 Feb
 2024 19:59:09 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-99G0032dbc91a4-991a-4df0-8871-a36f54e22966,
                    389DD5B1D10EB11086A8CF75D224061A50DF48A6) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
Date: Sun, 4 Feb 2024 19:59:08 +0100
From: Benjamin ROBIN <dev@benjarobin.fr>
To: Yordan Karadzhov <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, <dev@benjarobin.fr>
Subject: Re: [PATCH 04/34] kernelshark: Do not create a temporary container
 for looping over QMap
Message-ID: <gqbzlzqe3pss4opieve4c35xjgq7fgdgjh6iiq3zdm2ei5osnw@ac3adq75s3ez>
References: <20240114171723.14092-1-dev@benjarobin.fr>
 <20240114171723.14092-5-dev@benjarobin.fr>
 <56c65e9b-7536-3246-5250-7a68e36daa36@gmail.com>
 <7uyekhxkszucdofjsa23gqs4utdspx5u3vlhili6p72stbebux@djht53oakfff>
 <bc2f74e7-6e1b-7f2e-40e0-b40c842a7bb4@gmail.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <bc2f74e7-6e1b-7f2e-40e0-b40c842a7bb4@gmail.com>
X-ClientProxiedBy: DAG3EX1.mxp5.local (172.16.2.21) To DAG6EX2.mxp5.local
 (172.16.2.52)
X-Ovh-Tracer-GUID: 4e88c0fa-b0b4-4289-9583-7f8740835ccf
X-Ovh-Tracer-Id: 16032251727241240474
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrfedukedguddukecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvvefukfhfgggtuggjihesthdtsfdttddtvdenucfhrhhomhepuegvnhhjrghmihhnucftqfeukffpuceouggvvhessggvnhhjrghrohgsihhnrdhfrheqnecuggftrfgrthhtvghrnhepuddugefgkeeuteehfefhjedvheeludfhueeileegjefgtdevudfgvddtudeuuedvnecuffhomhgrihhnpegtphhprhgvfhgvrhgvnhgtvgdrtghomhenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddrleelpdelvddrudeiuddruddviedrgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqedpnhgspghrtghpthhtohepuddprhgtphhtthhopeihrdhkrghrrgguiiesghhmrghilhdrtghomhdplhhinhhugidqthhrrggtvgdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhohedvledpmhhouggvpehsmhhtphhouhht

On Sun, Feb 04, 2024 at 08:34:39PM +0200, Yordan Karadzhov wrote:
> 
> 
> On 1/28/24 22:30, Benjamin ROBIN wrote:
> > On Sun, Jan 21, 2024 at 07:16:01PM +0200, Yordan Karadzhov wrote:
> > > 
> > > 
> > > On 1/14/24 19:16, Benjamin ROBIN wrote:
> > > > Use const_iterator instead. Fix container-anti-pattern Clazy warning
> > > > 
> > > > Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
> > > > ---
> > > >    src/KsAdvFilteringDialog.cpp | 6 +++---
> > > >    1 file changed, 3 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/src/KsAdvFilteringDialog.cpp b/src/KsAdvFilteringDialog.cpp
> > > > index 4683c3d..247f912 100644
> > > > --- a/src/KsAdvFilteringDialog.cpp
> > > > +++ b/src/KsAdvFilteringDialog.cpp
> > > > @@ -276,8 +276,8 @@ void KsAdvFilteringDialog::_makeFilterTable()
> > > >    	headers << "Delete" << "Stream" << "Event" << " Id" << "Filter";
> > > >    	_table->init(headers, _filters.count());
> > > > -	for(auto f : _filters.keys()) {
> > > > -		QStringList thisFilter = _filters.value(f).split(":");
> > > > +	for (auto it = _filters.cbegin(), end = _filters.cend(); it != end; ++it) {
> > > 
> > > Do we need to use iterator here?
> > > Perhaps you can do something like:
> > > 
> > > for (const auto &[key, val] : _filters) {
> > 
> > Unfortunately, you cannot do that, as far as I know (this not compile).
> > C++ range-based for loop is using iterator behind the scene. See [1].
> > And there is still the problem of range-loop-detach (see patch 0005).
> > Using const iterator is the most explicit and safe way to iterate over a
> > container in Qt, so why not using it?
> 
> I see your point. I am applying this patch together with all v2 patches you
> sent.
> 
> Are you considering sending new version of the "[31/34] Fix comparison of
> integers of different signs warnings"?

I did not have time last weekend, nor this weekend to take a deep loop into it. 
Fixing types is not that easy:
 - I need a better understanding of the code base, otherwise I will break stuff.
 - I don't know if there are other projects that rely on these lib headers
   files. Is it possible to refactor every part of the project without breaking 
   something else?
 - My patch tried to fix at various places warnings using mainly cast, but there
   are so many other places where the types are wrong (or at least not the optimal
   one).
 - This task is not that small. It requires a bit more time.

So, in summary, this patch is currently on hold. I may work on it later this 
year... Sorry about that.

Thanks,
Benjamin

> > 
> > [1] https://en.cppreference.com/w/cpp/language/range-for
> > > Thanks!
> > > Y.
> > > 
> > > > +		QStringList thisFilter = it.value().split(":");
> > > >    		i1 = new QTableWidgetItem(thisFilter[0]);
> > > >    		_table->setItem(count, 1, i1);
> > > > @@ -285,7 +285,7 @@ void KsAdvFilteringDialog::_makeFilterTable()
> > > >    		i1 = new QTableWidgetItem(thisFilter[1]);
> > > >    		_table->setItem(count, 2, i1);
> > > > -		i2 = new QTableWidgetItem(tr("%1").arg(f));
> > > > +		i2 = new QTableWidgetItem(tr("%1").arg(it.key()));
> > > >    		_table->setItem(count, 3, i2);
> > > >    		i3 = new QTableWidgetItem(thisFilter[2]);

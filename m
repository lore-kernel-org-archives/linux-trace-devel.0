Received: from 9.mo548.mail-out.ovh.net (9.mo548.mail-out.ovh.net [46.105.48.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEDC3C461
	for <linux-trace-devel@vger.kernel.org>; Sun, 28 Jan 2024 21:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.105.48.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706478421; cv=none; b=O44RiS7z17s5Bn/1F4uZ25XFOcxJIU5LBhEFFz4dlwEyVqClFYkqOs7pIU4Hy+lNpatQAECpNfT7/G9Kbk8Ky1TtwbeUIW6R/+PbrxI5XiXBaqhv2jl85FnzjLmSyUb55jDn5p3GuTRzW+4S6qLkyrNK2s7NC6o+QT4RmJNPHPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706478421; c=relaxed/simple;
	bh=IFBG0P7mP9n2k+k8Ynpo4Y88Be0YaG0FIG2NkLt8GCg=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BmjS5YYVf47gYmmccj4WqLZ+S/NSJPf5dmVdizCEjcqD4s0+wkL7XqEqtZZzUhoHhzbh5CSfVNOZQqjQOHcEGbqFjUxrL9CeNbYyDfKN3ISxXoEBrP5l13t5QiDmN4n0aqRKb7wBOYJdHi8qVY0xU14e/tsxJ1P7ukS46vborVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr; spf=pass smtp.mailfrom=benjarobin.fr; arc=none smtp.client-ip=46.105.48.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.108.17.201])
	by mo548.mail-out.ovh.net (Postfix) with ESMTPS id BEC98213AA;
	Sun, 28 Jan 2024 21:30:13 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.108) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 28 Jan
 2024 22:30:13 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-108S0028459b236-820d-41ab-865d-64c17000c3c2,
                    F6BBF12166BF17D31185B0BF3C367C102A143481) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
Date: Sun, 28 Jan 2024 22:30:11 +0100
From: Benjamin ROBIN <dev@benjarobin.fr>
To: Yordan Karadzhov <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 04/34] kernelshark: Do not create a temporary container
 for looping over QMap
Message-ID: <7uyekhxkszucdofjsa23gqs4utdspx5u3vlhili6p72stbebux@djht53oakfff>
References: <20240114171723.14092-1-dev@benjarobin.fr>
 <20240114171723.14092-5-dev@benjarobin.fr>
 <56c65e9b-7536-3246-5250-7a68e36daa36@gmail.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <56c65e9b-7536-3246-5250-7a68e36daa36@gmail.com>
X-ClientProxiedBy: DAG4EX2.mxp5.local (172.16.2.32) To DAG6EX2.mxp5.local
 (172.16.2.52)
X-Ovh-Tracer-GUID: 9f15d90a-4790-4ac0-a56e-79a361dfeebf
X-Ovh-Tracer-Id: 14367890189595991962
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrfedtvddgudegkecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvvefukfhfgggtuggjihesthdtsfdttddtvdenucfhrhhomhepuegvnhhjrghmihhnucftqfeukffpuceouggvvhessggvnhhjrghrohgsihhnrdhfrheqnecuggftrfgrthhtvghrnhepuddugefgkeeuteehfefhjedvheeludfhueeileegjefgtdevudfgvddtudeuuedvnecuffhomhgrihhnpegtphhprhgvfhgvrhgvnhgtvgdrtghomhenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtkedpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeouggvvhessggvnhhjrghrohgsihhnrdhfrheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohephidrkhgrrhgrugiisehgmhgrihhlrdgtohhmpdhlihhnuhigqdhtrhgrtggvqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehgeekpdhmohguvgepshhmthhpohhuth

On Sun, Jan 21, 2024 at 07:16:01PM +0200, Yordan Karadzhov wrote:
> 
> 
> On 1/14/24 19:16, Benjamin ROBIN wrote:
> > Use const_iterator instead. Fix container-anti-pattern Clazy warning
> > 
> > Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
> > ---
> >   src/KsAdvFilteringDialog.cpp | 6 +++---
> >   1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/src/KsAdvFilteringDialog.cpp b/src/KsAdvFilteringDialog.cpp
> > index 4683c3d..247f912 100644
> > --- a/src/KsAdvFilteringDialog.cpp
> > +++ b/src/KsAdvFilteringDialog.cpp
> > @@ -276,8 +276,8 @@ void KsAdvFilteringDialog::_makeFilterTable()
> >   	headers << "Delete" << "Stream" << "Event" << " Id" << "Filter";
> >   	_table->init(headers, _filters.count());
> > -	for(auto f : _filters.keys()) {
> > -		QStringList thisFilter = _filters.value(f).split(":");
> > +	for (auto it = _filters.cbegin(), end = _filters.cend(); it != end; ++it) {
> 
> Do we need to use iterator here?
> Perhaps you can do something like:
> 
> for (const auto &[key, val] : _filters) {

Unfortunately, you cannot do that, as far as I know (this not compile).
C++ range-based for loop is using iterator behind the scene. See [1].
And there is still the problem of range-loop-detach (see patch 0005).
Using const iterator is the most explicit and safe way to iterate over a
container in Qt, so why not using it?

[1] https://en.cppreference.com/w/cpp/language/range-for
 
> Thanks!
> Y.
> 
> > +		QStringList thisFilter = it.value().split(":");
> >   		i1 = new QTableWidgetItem(thisFilter[0]);
> >   		_table->setItem(count, 1, i1);
> > @@ -285,7 +285,7 @@ void KsAdvFilteringDialog::_makeFilterTable()
> >   		i1 = new QTableWidgetItem(thisFilter[1]);
> >   		_table->setItem(count, 2, i1);
> > -		i2 = new QTableWidgetItem(tr("%1").arg(f));
> > +		i2 = new QTableWidgetItem(tr("%1").arg(it.key()));
> >   		_table->setItem(count, 3, i2);
> >   		i3 = new QTableWidgetItem(thisFilter[2]);

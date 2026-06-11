Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61612EA731
	for <linux-trace-devel@vger.kernel.org>; Thu, 11 Jun 2026 13:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781183101; cv=none; b=qNCmdJQ/oa0H+p4c7m+3LoHipkEpWAbVqIVCC3ZRM0+k6bgwjRtU52OGk0Qhk67TL3KzJ/aAhHXmBQHvIOweBUSfhouMVegzw/deP222AxAJY5tlW0K3UIRAU8rUWLJwK8rcM3+PZDf/+atTaslPWz6Ghn3pR9Y7Y5QH0QMwDM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781183101; c=relaxed/simple;
	bh=cu00XBoLlo82UBCOEpolwSg+TfQDjrYrxOL/x5Nv5KY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ki24x9524u3hCPgYz7WuKqde2g3iSjlGwpUkH/Y4vqJM9wydecV1bSXn+zK+iP1A6ZJkOrSyprhrdYF2dZE61ZbsWgNVSSpi4JeELxgR4cylHzD890kSgFIYFRsWcS83YlxpHXKeJptauNdyB0o1rFHH/jB0MVRfIYo4kX5jx4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 608721C35CA;
	Thu, 11 Jun 2026 13:04:51 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf08.hostedemail.com (Postfix) with ESMTPA id 7C37220025;
	Thu, 11 Jun 2026 13:04:49 +0000 (UTC)
Date: Thu, 11 Jun 2026 09:04:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Christopher Hoy Poy <choypoy@linuxfoundation.org>
Cc: Yordan Karadzhov <y.karadz@gmail.com>, Linux Trace Devel
 <linux-trace-devel@vger.kernel.org>, helpdesk@kernel.org, Konstantin
 Ryabitsev <mricon@kernel.org>
Subject: Re: Documentation update to KernelShark
Message-ID: <20260611090449.7b9d6322@gandalf.local.home>
In-Reply-To: <CAKkv+gx_wkbBGVR7ucGTs++U52B0siVfvYN5phauuy=uJB92=w@mail.gmail.com>
References: <20260529115528.1d0f92a5@fedora>
	<914607e6-1a51-e872-6383-292efecec61e@gmail.com>
	<20260609112223.3a17b5ba@fedora>
	<CAKkv+gx_wkbBGVR7ucGTs++U52B0siVfvYN5phauuy=uJB92=w@mail.gmail.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4ipqzwhsms4pd491uzs54mrhe7qg3iyq
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: 7C37220025
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18fSLcCLR71ACdOg4zi9+xmLkvUcGFv4Ik=
X-HE-Tag: 1781183089-726301
X-HE-Meta: U2FsdGVkX1+eQKPdfgwTiKuxqWquHx6UAaSNR46Ug1uhRdAGpXgodBcSTH/qY2cVTfbd6BkTRF+6/pUxIwTK85sJwogkCq59Gipc07PRzzaKcVAuHGBRB18fwR9FkgKELHPmmlg6yUiRdx4E9drcCUPD6+1vJR5yQYw3L6FHegLrcweFf2e8eTfIMQZei3a/QSjL9bSDvaO1D50q2+qdCMMfVwX0SLcKPuQJE5BvORVVuAuXmszcEIsihqj1qYbKjuLGoFbWMZoxqhiVh2bezDpvVH1n1fNpKEQzMOO9iwoqkQNTXC23DN8GWG9taaEB0YwKuLr44Q5T5Oie7+pkgpYxJlvraeTySbrz9FyGKXwN/dR4VXOYMnDXUbfnuJlS7cNmNjjYxfMw1j8nSc3rJn4NSNbeMQsVFq6LilneaI8yUdOa1D5Bt48lH7dELv/n25VRe/OiOwHp++LgvbsQPuIDLE0GEArucUO5ayEu1v4=


Thanks Christopher!

-- Steve


On Wed, 10 Jun 2026 12:25:37 +0800
Christopher Hoy Poy <choypoy@linuxfoundation.org> wrote:

> Hi Steven, Yordan
>=20
> This is done.
>=20
> Any queries, please reach out to helpdesk@kernel.org
>=20
> Chris Hoy Poy
> Senior Systems Engineer
> Core Projects
> The Linux Foundation
> Perth, Western Australia (GMT:+8)
>=20
> On Tue, Jun 9, 2026 at 11:42=E2=80=AFPM Steven Rostedt <rostedt@goodmis.o=
rg> wrote:
> >
> > On Thu, 4 Jun 2026 12:57:48 +0300
> > Yordan Karadzhov <y.karadz@gmail.com> wrote:
> > =20
> > > Hi Steven,
> > >
> > > I am very happy to see a patch from you :-)
> > >
> > > The patch has been applied to the repo.
> > >
> > > I do have a PatchWork account. My username is ykaradzhov. =20
> >
> > Hi Konstantin,
> >
> > Is it possible to add Yordan's id to the list of possible "delegate to"
> > entries? This is for "Linux-Trace Development":
> >
> >   https://patchwork.kernel.org/project/linux-trace-devel/list/
> >
> > Thanks,
> >
> > -- Steve
> >
> > =20
> > >
> > > Cheers,
> > > Yordan
> > >
> > >
> > > On 5/29/26 18:55, Steven Rostedt wrote: =20
> > > > Hi Yordan,
> > > >
> > > > Can you apply this patch to the  repo:
> > > >
> > > >    https://patchwork.kernel.org/project/linux-trace-devel/patch/202=
51031115513.41b86970@gandalf.local.home/
> > > >
> > > > Also, you probably should have your name added to the PatchWork so =
that
> > > > I can delegate KernelShark patches to you, and that will make it ea=
sier
> > > > for what is needed for KernelShark.
> > > >
> > > > Do you have PatchWork account? If not, we should get you one (I Cc'd
> > > > helpdesk@kernel.org to let them know you need one too).
> > > >
> > > > -- Steve =20
> >
> > =20


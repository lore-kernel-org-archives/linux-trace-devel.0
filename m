Received: from smtpcmd0986.aruba.it (smtpcmd0986.aruba.it [62.149.156.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEEE22A1D4
	for <linux-trace-devel@vger.kernel.org>; Sun,  8 Feb 2026 22:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.156.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770589064; cv=none; b=uyNG1ntdl6IuqqAVhkL16eZUQIM2MX5UCeICmkP0kl66iJq6fZwaDOAzfDF8sIitL5Z2/ZDollUO9jLKwXuRMwKBcmewxjTsslMWzLKp0N6eoOfuOKNVNW74dnk9dV9ceA8pbBBYgH1fC+jlBpqn6n8EHHw3afRBW2yh6277xuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770589064; c=relaxed/simple;
	bh=CvTloiE0dsNcTpVQY5fWRxFQ93vvHUdfzkHERc/I6G4=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=stKhkdM7uOIWed3EV7L6N2cV4amrhWOUa51pYRDIEWhoHeXlrbPsCIJnDhiOacTflDx28g/0FT3mOpIJ2qPIpp3H/qklJRzyEyG0y3h8WccN+Y1Ix1qb44frIzEsgB/gocESeZJePGVIGFzETyGKJRlcS24RYqYyBKrvGKFtH7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=benettiengineering.com; spf=pass smtp.mailfrom=benettiengineering.com; dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b=AgkY4mmJ; arc=none smtp.client-ip=62.149.156.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=benettiengineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benettiengineering.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b="AgkY4mmJ"
Received: from smtpclient.apple ([84.33.84.190])
	by Aruba SMTP with ESMTPSA
	id pD33vR3Hb4bDkpD34v9MJr; Sun, 08 Feb 2026 23:14:34 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1770588874; bh=CvTloiE0dsNcTpVQY5fWRxFQ93vvHUdfzkHERc/I6G4=;
	h=Content-Type:From:Mime-Version:Subject:Date:To;
	b=AgkY4mmJ9iw17tJbHL/Z+bpwKD/1AOWXCutHAubSkcx4Db4MYdeR2AxvdqTJwYVbV
	 ypHEKiyCfCMKtwEWj7RkMnX0f87f249niAayAuAujsfjVTyPIIGZpF4dJCtSpsYTt3
	 iiQ14oMbGWXUM2IalX0XEQRQV1ISwAJ1wmk4Rj5wPqBlF2EhlsQPKMNFt11GUEYb3y
	 PPDYxZPvyQh/GeDNDHUwTwFSfJO81kIMSWUd/vcFa33MVm1XU5AcC2NNbB0Sch1ktG
	 CGfYG3lnfYSKUrngZPO5P9zbcjs5oUrqUFl8T9OHPpSRmuQ3Sfmen0nLrZDKfKmhgT
	 wFUrxFlOe8M0Q==
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Giulio Benetti <giulio.benetti@benettiengineering.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: Build failure bft for trace-cmd and libtraceevent
Date: Sun, 8 Feb 2026 23:14:32 +0100
Message-Id: <406EA18E-BDD3-4204-A58F-B7F04450FA9F@benettiengineering.com>
References: <20260208170123.37d468a0@robin>
Cc: linux-trace-devel@vger.kernel.org
In-Reply-To: <20260208170123.37d468a0@robin>
To: Steven Rostedt <rostedt@goodmis.org>
X-Mailer: iPhone Mail (23C71)
X-CMAE-Envelope: MS4xfP31hefrVjRZ+/v1rLBkvLsPFnwfD7kjReu8sSYyV+8HvMz5d4vMzq6Wc67DRG17iI9svY9rDcDEiixhWJDcW+g1U67xfOGyoiXECtNZ/kYN1u5mCmKI
 aj85ylgKeJzRigciYGctLGBU7il6jnY5pjRnMMQMn1ERyJSLTUyxh0vBzPIMUgPs02MqG5w29N9qQaMOLEuegsBVpBIK6vW+0pBUvQmNY6CLf4P6ld5tfdzW
 GL1namWfPaJrL8IuAe/eg9htvdkY9ga5tMbGcNHw/74=



> Il giorno 8 feb 2026, alle ore 23:01, Steven Rostedt <rostedt@goodmis.org>=
 ha scritto:
>=20
> =EF=BB=BFOn Sun, 8 Feb 2026 22:44:24 +0100
> Giulio Benetti <giulio.benetti@benettiengineering.com> wrote:
>=20
>> Oh, I've forgotten to post the build failure, here it is and it's due to
>> dealing with different Linux versions:
>=20
> OK, if it is a build failure, we should add logic to make sure it
> builds properly and if not, warn and build without BTF. Kind of like
> what trace-cmd did when I was first started developing this:
>=20
>  https://lore.kernel.org/20260203233451.2118849-5-rostedt@goodmis.org

Oh, ok. I=E2=80=99m going to follow that commit and add btf option to disabl=
e btf to trace-cmd too.
At the moment it only checks for libtraceevent version and that won=E2=80=99=
t be sufficient.

Thank you for taking care

Best regards
Giulio

>=20
> -- Steve


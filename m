Received: from manage.vyzra.com (unknown [104.128.60.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AB73451C6
	for <linux-trace-devel@vger.kernel.org>; Fri, 17 Oct 2025 13:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.128.60.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760706312; cv=none; b=LPnjObYSoBqAoAPoBhN32Tty2g/FeAcl6uIW+uRjkDy94/tyK6hdin/fMsIMi7x7KIAcsIozZTR3bJvVVlz/9U6gFicjvFC++Q7fozbZvJ7G+tCrS5537JYWnlfjm6Od89ADO9x/d8Rz5Gj1u1vbHU2Y9ningIrWjSQIgT883mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760706312; c=relaxed/simple;
	bh=biLnUx9jTTyVdIbdiavoTAgEZeIqqOihfb373MH/e18=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uys8L4jEqrN8qj0hfn0azyn5FHFFEEF5LEHYdQD3WDKRxCZBYEgSOFrwrxzTXRWc16O49NNsvVBk7TUbNVg7nBvfswZRaYC/cDiFrslsBlYiyLX8/BBGQEFeZgHYT09iCNq/68L1XduKZqfycKEJ3OrCtKjXNb0+AYshEvtMRr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debtmanager.org; spf=none smtp.mailfrom=manage.vyzra.com; dkim=fail (0-bit key) header.d=debtmanager.org header.i=@debtmanager.org header.b=lePED9qs reason="key not found in DNS"; arc=none smtp.client-ip=104.128.60.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debtmanager.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=manage.vyzra.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=debtmanager.org header.i=@debtmanager.org header.b="lePED9qs"
Received: from debtmanager.org (unknown [103.237.86.103])
	by manage.vyzra.com (Postfix) with ESMTPA id 638E85338260
	for <linux-trace-devel@vger.kernel.org>; Fri, 17 Oct 2025 07:45:36 -0500 (CDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=debtmanager.org;
	s=DKIM2021; t=1760705137; h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
	bh=Aj8bDacQlJB5qNMC5+yWWged1+K/M8YReXQkzUminbQ=;
	b=lePED9qsrS8LRmWnams196Kr//JDQw+uobhplm29enlsl3OUKLiphf5QCX5yGTbcldw/Jc
	oUSW09U4Q20Cybr7wTnwMJnfyBHCEb7otxdvy25BQRhnuYCA/BkiCkZnN8QXuXIDR4dEtC
	hjGn2rwH5PFijhwkoZSdNEK03N3EzU7PRgMH0lBvryxy64P7iVDaMeYIoHJbELZqkVFsnX
	zJhkO59Opi1TGCy+shgCHemqCFadTHMiV7qmbYuj3JS/iakwufZRD3GeuKFTMsRkPs88jz
	Hcy6rscQLHOlqB+iNChRejm5c5DCStIFAz+dQUwNDLvZxHQba6SuD7y/XrAF4g==
Reply-To: vlad.dinu@rdslink.ro
From: "Vlad Dinu" <info@debtmanager.org>
To: linux-trace-devel@vger.kernel.org
Subject: *** Urgent Change ***
Date: 17 Oct 2025 05:45:34 -0700
Message-ID: <20251017054534.EDD7947478E6E278@debtmanager.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Score: -0.10

Hello,

I am Vlad Dinu, the newly appointed Director of IMF Legal=20
Affairs, Security and Investigation. I have been given the=20
responsibility to look into all the payments that are still=20
pending and owed to fund beneficiaries / scam victims worldwide.

This action was taken because there have been issues with some=20
banks not being able to send or release money to the correct=20
beneficiary accounts. We have found out that some directors in=20
different organizations are moving pending funds to their own=20
chosen accounts instead of where they should go.

During my investigation, I discovered that an account was=20
reported to redirect your funds to a bank in Sweden.
The details of that account are provided below. I would like you=20
to confirm if you are aware of this new information, as we are=20
now planning to send the payment to the account mentioned.

NAME OF BENEFICIARY: ERIK KASPERSSON
BANK NAME: SWEDBANK AB
ADDRESS: REPSLAGAREGATAN 23A, 582 22 LINK=C3=96PING, SWEDEN
SWIFT CODE: SWEDSESS
ACCOUNT NUMBER: 84806-31282205


A payment instruction has been issued by the Department of=20
Treasury for an immediate release of your payment to the bank=20
account above without further prejudice. We cannot approve or=20
schedule payment to the 

given bank account without your confirmation. May we proceed with=20
the transfer to the Beneficiary: Erik Kaspersson, bank account in=20
Sweden?

I await your urgent response.

Mr. Vlad Dinu.

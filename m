Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6CB193094
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594949; cv=none; b=bM2pCvAai92qY0w35DwFeng9hTANUdq81fGfHgXqqZSDmxnYb5RxbNng95VYqT8eBjPkZZscG2xv0OuO4LPhBnDKuKDKi8IiGMgqCaP6S9N1YWopsg+0SAOoWQfUqPppqI5l63BNC6schp13okw8/blf/cpVauY7wfalQlquMzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594949; c=relaxed/simple;
	bh=W2bsMX+bwKKgs7RPDvcwZLAbIr7EjgWgSSo8b/TskMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DFq1zEe6UK3hr0GgVh22i0chkFxGFfwXrjgqgQRK6AIPvS/PhcBrefZqXXKcHCRIGM63unfo/+8H8x6UlTl4Rdj7xaZFiYHgzMQfLahGFtr2TBJwcQ8d3d4gBeuak6lfp8iE58nak3lntapp9iEPy7QTblG97vnxs2ugzGJjYXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gQ+nlmEu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gQ+nlmEu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4LsHWYBIxF7f92vylZzYoxYL6lJ8P9abttdny3bqni8=;
	b=gQ+nlmEuK2CyD3NyV/GwYOQJV0uQirC3APZw4vCqyp4uS6B9wuNwOM8EtMNTpdLqu6yBrn
	LupivFVv72yih0m2eirMul4aIt51NmKtXFV9WcuBTaUPli8sRvl+WTp1EqoQAxEbt1tWDH
	dSPixud6fzcbVMk1tYG4bXOmgxHZmfc=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-54-4pSwPj2NPMaQG-h6SHTr4A-1; Wed,
 05 Jun 2024 09:42:24 -0400
X-MC-Unique: 4pSwPj2NPMaQG-h6SHTr4A-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 974151954B3C;
	Wed,  5 Jun 2024 13:42:23 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 0F24619560AE;
	Wed,  5 Jun 2024 13:42:20 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:42:19 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 23/38] trace-cmd lib: prevent buffer overrun in read_string()
Date: Wed,  5 Jun 2024 15:40:38 +0200
Message-ID: <20240605134054.2626953-24-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

In read_string() we try to write a null character at str(size), which
is out of range:

	if (str) {
		size += i + 1;
		str = realloc(str, size);
		if (!str)
			return NULL;
		memcpy(str + (size - i), buf, i);
		str[size] = 0;
	}

The character that should be zeroed is supposed to be at the size - 1
index, which is the size of str prior the reallocation plus i. We also
know that buf[i] == 0 so we can simply memcpy that too instead of
zeroing it by hand. That simplifies the code a little.

Fixes an OVERRUN error (CWE-119)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 lib/trace-cmd/trace-input.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 3284dbd4..c485acea 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -447,15 +447,13 @@ static char *read_string(struct tracecmd_input *handle)
 		str = realloc(str, size);
 		if (!str)
 			return NULL;
-		memcpy(str + (size - i), buf, i);
-		str[size] = 0;
+		memcpy(str + (size - i), buf, i + 1);
 	} else {
 		size = i + 1;
 		str = malloc(size);
 		if (!str)
 			return NULL;
-		memcpy(str, buf, i);
-		str[i] = 0;
+		memcpy(str, buf, i + 1);
 	}
 
 	return str;
-- 
2.44.0


Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 067B1C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 17:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D248B613B0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 17:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243597AbhDPRsC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Apr 2021 13:48:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:46282 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235563AbhDPRsC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Apr 2021 13:48:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1618595256; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4pWIhciCpH9wJeWRXxRsXGPZHxTUF+kwViUsGkwhcRQ=;
        b=DG3B7YHX/uRcfOEaIFsbOIRP/vXabBvQmWTDawuD8xWCBg4OnsywW7FL93tIddz9dDNdie
        UiID6Tu5gXVam88NzyxdM9bwDUrEAf66FVvrXhECfEg4jbro/PyrrVHTTj37P5egiXbq/5
        1IXxD9xjkNfzGTpjNkzkAHRbXOGkZao=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1E4E9ADDB;
        Fri, 16 Apr 2021 17:47:36 +0000 (UTC)
Message-ID: <70d698ef3074a50576da48587aaf4ce2eea9585f.camel@suse.com>
Subject: Re: [RFC] Simple tool for VMEnters/VMExits matching and trace
 validation
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Stefano De Venuto <stefano.devenuto99@gmail.com>,
        rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Date:   Fri, 16 Apr 2021 19:47:34 +0200
In-Reply-To: <20210416164653.2949-1-stefano.devenuto99@gmail.com>
References: <20210416164653.2949-1-stefano.devenuto99@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-yTfy3k9wu37V6sn06XU+"
User-Agent: Evolution 3.40.0 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-yTfy3k9wu37V6sn06XU+
Content-Type: multipart/mixed; boundary="=-oC0tB1YivuIQ3798Bhme"


--=-oC0tB1YivuIQ3798Bhme
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2021-04-16 at 18:46 +0200, Stefano De Venuto wrote:
> Add a tool in examples/ that scans a merged host + guest trace and
> search for host events that are inside a vmentry/vmexit block (and
> vice-versa for guest events ouside the block) and report the found
> ones.
>=20
> It can be useful as a starting point for identifying issues of for
> checking the effectiveness of host/guest traces synchronization, or
> even for improving the placing of the tracepoints in the kernel.
>=20
> Signed-off-by: Stefano De Venuto <stefano.devenuto99@gmail.com>
>
Just as an example, by using this tool we noticed that there are a
bunch of host events that, despite happening before a VMEnter (and
after a VMExit) were shown in the trace inside of a kvm_enter -
kvm_exit "block".

Stefano, do you still have an example of how the trace looks like? Can
you paste it here?

Stefano has also already developed the attached kernel patch. Which we
plan to submit upstream as soon as we've tested properly on Intel
hardware as well. But that's another story (although, feel free to
provide any feedback already, if interested).

Thanks and Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-oC0tB1YivuIQ3798Bhme
Content-Disposition: attachment; filename="0001-Moved-kvm_entry-and-kvm_exit-tracepoints.patch"
Content-Type: text/x-patch; name="0001-Moved-kvm_entry-and-kvm_exit-tracepoints.patch";
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

=46rom 4a93ecd7f8354bbfa724dec6af357c23596dea64 Mon Sep 17 00:00:00 2001
From: Stefano De Venuto <stefano.devenuto99@gmail.com>
Date: Fri, 16 Apr 2021 08:58:15 +0200
Subject: [PATCH] Moved kvm_entry and kvm_exit tracepoints

---
 arch/x86/kvm/svm/svm.c |  8 ++++----
 arch/x86/kvm/vmx/vmx.c | 10 +++++-----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3442d44ca53b..84c268ea3a31 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3262,8 +3262,6 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpat=
h_t exit_fastpath)
 	struct kvm_run *kvm_run =3D vcpu->run;
 	u32 exit_code =3D svm->vmcb->control.exit_code;
=20
-	trace_kvm_exit(exit_code, vcpu, KVM_ISA_SVM);
-
 	/* SEV-ES guests must use the CR write traps to track CR registers. */
 	if (!sev_es_guest(vcpu->kvm)) {
 		if (!svm_is_intercept(svm, INTERCEPT_CR0_WRITE))
@@ -3744,8 +3742,6 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_=
vcpu *vcpu)
 {
 	struct vcpu_svm *svm =3D to_svm(vcpu);
=20
-	trace_kvm_entry(vcpu);
-
 	svm->vmcb->save.rax =3D vcpu->arch.regs[VCPU_REGS_RAX];
 	svm->vmcb->save.rsp =3D vcpu->arch.regs[VCPU_REGS_RSP];
 	svm->vmcb->save.rip =3D vcpu->arch.regs[VCPU_REGS_RIP];
@@ -3798,8 +3794,12 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm=
_vcpu *vcpu)
 	 */
 	x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
=20
+	trace_kvm_entry(vcpu);
+
 	svm_vcpu_enter_exit(vcpu, svm);
=20
+	trace_kvm_exit(svm->vmcb->control.exit_code, vcpu, KVM_ISA_SVM);
+
 	/*
 	 * We do not use IBRS in the kernel. If this vCPU has used the
 	 * SPEC_CTRL MSR it may have left it on; save the value and
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index eb69fef57485..d0ca562999b6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6653,8 +6653,6 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (vmx->emulation_required)
 		return EXIT_FASTPATH_NONE;
=20
-	trace_kvm_entry(vcpu);
-
 	if (vmx->ple_window_dirty) {
 		vmx->ple_window_dirty =3D false;
 		vmcs_write32(PLE_WINDOW, vmx->ple_window);
@@ -6710,9 +6708,14 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu=
)
 	 */
 	x86_spec_ctrl_set_guest(vmx->spec_ctrl, 0);
=20
+	trace_kvm_entry(vcpu);
+
 	/* The actual VMENTER/EXIT is in the .noinstr.text section. */
 	vmx_vcpu_enter_exit(vcpu, vmx);
=20
+	vmx->exit_reason =3D vmcs_read32(VM_EXIT_REASON);
+	trace_kvm_exit(vmx->exit_reason, vcpu, KVM_ISA_VMX);
+
 	/*
 	 * We do not use IBRS in the kernel. If this vCPU has used the
 	 * SPEC_CTRL MSR it may have left it on; save the value and
@@ -6772,12 +6775,9 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu=
)
 		return EXIT_FASTPATH_NONE;
 	}
=20
-	vmx->exit_reason =3D vmcs_read32(VM_EXIT_REASON);
 	if (unlikely((u16)vmx->exit_reason =3D=3D EXIT_REASON_MCE_DURING_VMENTRY)=
)
 		kvm_machine_check();
=20
-	trace_kvm_exit(vmx->exit_reason, vcpu, KVM_ISA_VMX);
-
 	if (unlikely(vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
 		return EXIT_FASTPATH_NONE;
=20
--=20
2.30.2

=0D
--=-oC0tB1YivuIQ3798Bhme--

--=-yTfy3k9wu37V6sn06XU+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmB5zbYACgkQFkJ4iaW4
c+7I6BAAsXSGub+5+KBW6iD79yEENhzlUKvrCr6jKmaIm9qv8dAnwT2cKCB8SVl/
iB9MVGQGIDmVjrWbNvxPPzpG4q8s+5MNThu9/XNNhu4/JZgZyOYrw8A5K84/C75S
KVMza5xDJwEHUWiPDQvgBqQmMkubeLhomhaL9GNEvvCAMjlsYaXuHpdNRO+I4f9X
5DmDZ56wfscPUQR+jb967n9d+bXt/Awu8CgZEwfdPQ/P+fObrx86AlgzTt3SHnil
ATuRJHR+QheciNJd20Tz+8sJqm75YWZu0KoZQVRxhbFtQ8Zn0FXaU+0OqGtm/48r
fHEPOt0FhdWxnPMtz2IgkmjlAkBSF8khNN0oee9dRH3Qq+UqyrusOIxGRH6C8REH
6pNGvPfRBq9W37FrmHO2E8T6VPMykKHiU30JcoFwnSPg3pDi5ZS8Uco8IVdESw+e
BZzkMfVhEnr/2ZmVaezL4/NRyCT4nl7w96Ul+tI9gw5YaXIf6/4DJhuV499AQ61J
T3Ugh46fe9rZX5kFqN3dvcwD8c3/evl+bLw92l+lIrT0ZypSKuff5fMNZgalKlnp
QzAJMEVkDEaz28pkMRn+l6kD4iPuEk6Ee3s0Qh7lUHLV6dPmcdJ4lOepvWd+YpHm
gZ2Ju0fLV03k8F9jvbHyqYs9xq1EZ6t9a4ypjgmQok6MxPX3K18=
=Dcpq
-----END PGP SIGNATURE-----

--=-yTfy3k9wu37V6sn06XU+--

